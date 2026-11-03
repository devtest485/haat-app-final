import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/services.dart';

/// Why enabling or using biometrics did not happen.
enum BiometricUnavailable {
  /// The handset has no fingerprint reader or face sensor the platform rates strong
  /// enough to gate a key with.
  noHardware,

  /// It has the hardware, but the owner has not enrolled a fingerprint or face.
  notEnrolled,

  /// The user dismissed the prompt, or chose the negative button.
  cancelled,

  /// The device key was destroyed because the biometrics on the phone changed. Nothing
  /// is broken — the owner enrols again — but the old key will never sign anything.
  keyInvalidated,

  /// This platform has no key store implementation behind the channel. Android does;
  /// iOS is not written yet. See [BiometricKeyStore].
  keyUnsupported,

  /// The platform refused for a reason worth logging rather than guessing at.
  platformError,
}

/// The outcome of asking for a device key.
sealed class BiometricEnrolment {
  const BiometricEnrolment();
}

/// A key exists in secure hardware, and [publicKey] is its public half.
final class BiometricEnrolled extends BiometricEnrolment {
  const BiometricEnrolled(this.publicKey);

  /// SPKI, base64. Sent to `POST /auth/biometric`; the private half stays in hardware.
  final String publicKey;
}

/// Not enrolled, and [reason] says why.
final class BiometricRefused extends BiometricEnrolment {
  const BiometricRefused(this.reason, {this.detail});

  final BiometricUnavailable reason;
  final String? detail;
}

/// The outcome of asking the device key to sign a challenge.
sealed class BiometricSignature {
  const BiometricSignature();
}

/// The owner passed the prompt and the hardware signed.
final class BiometricSigned extends BiometricSignature {
  const BiometricSigned(this.signature);

  /// The ECDSA signature, DER, base64 — what `POST /auth/biometric/verify` checks.
  final String signature;
}

/// No signature, and [reason] says why. [BiometricUnavailable.cancelled] is the ordinary
/// case and means the person chose something else, not that anything went wrong.
final class BiometricSignRefused extends BiometricSignature {
  const BiometricSignRefused(this.reason, {this.detail});

  final BiometricUnavailable reason;
  final String? detail;
}

/// Biometric sign-in, over a key that lives in the phone's secure hardware.
///
/// ## What the backend expects
///
/// `POST /auth/biometric` takes the public half of a **P-256 key pair generated inside
/// the phone's secure hardware** — the Android Keystore's TEE or StrongBox, or the iOS
/// Secure Enclave — and `/auth/biometric/verify` takes an ES256 signature over a
/// single-use challenge the server issued. The security property is that the private key
/// cannot leave that hardware, so a signature proves the request came from this handset
/// with its owner's fingerprint on the sensor.
///
/// **No key is ever generated in Dart.** A private key sitting in the app's own storage
/// can be copied off a rooted device, which removes the entire reason the endpoint is
/// designed this way — and it would look finished while being worth less than no
/// biometrics at all.
///
/// ## Where the work actually happens
///
/// Behind a method channel, in [_channel]:
///
/// - **Android** — `BiometricKeyBridge.kt`. `KeyPairGenerator` on `AndroidKeyStore` with
///   `setUserAuthenticationRequired(true)`, then `BiometricPrompt` holding the
///   `Signature` as its crypto object. Written and working.
/// - **iOS** — not written. `SecKeyCreateRandomKey` with `kSecAttrTokenIDSecureEnclave`
///   and an access control of `biometryCurrentSet`, then `SecKeyCreateSignature` with
///   `ecdsaSignatureMessageX962SHA256`, would be the shape of it.
///
/// A platform with nothing behind the channel raises `MissingPluginException`, which
/// becomes [BiometricUnavailable.keyUnsupported] — so iOS says biometrics are not ready
/// and offers the passcode, rather than failing in a way nobody can read.
class BiometricKeyStore {
  BiometricKeyStore({MethodChannel? channel})
      : _channel = channel ?? const MethodChannel(_channelName);

  static const _channelName = 'com.mycompany.haat/biometric_key';

  final MethodChannel _channel;

  /// Whether a strong biometric is usable on this handset, or the reason it is not.
  ///
  /// "Strong" is the platform's own rating, and it is the one that matters: a weak face
  /// unlock passes a general "has biometrics" check and then cannot gate a hardware key,
  /// so asking the general question only moves the failure somewhere less explicable.
  Future<BiometricUnavailable?> availability() async {
    try {
      return _reason(await _channel.invokeMethod<String>('availability'));
    } on PlatformException catch (error) {
      return _reason(error.code) ?? BiometricUnavailable.platformError;
    } on MissingPluginException {
      return BiometricUnavailable.keyUnsupported;
    }
  }

  /// Whether this device already holds a key.
  ///
  /// The ground truth for whether to offer biometric sign-in on the login screen. The
  /// server's opinion is asked next, when the challenge is requested — but there is no
  /// point asking it on a handset that could not answer a challenge anyway.
  Future<bool> hasKey() async {
    try {
      return await _channel.invokeMethod<bool>('hasKey') ?? false;
    } catch (error) {
      // Broad on purpose: MissingPluginException and PlatformException both mean the
      // same thing to a caller deciding whether to offer the option. Logged rather than
      // swallowed, because "the button silently did not appear" is otherwise a fault
      // with nothing at all to go on.
      debugPrint('Biometric key check failed: $error');

      return false;
    }
  }

  /// Creates a device-bound key pair and returns its public half.
  ///
  /// Replaces any key already on the device — one enrolment per handset, so that
  /// removing biometrics and setting them up again cannot leave an older key behind that
  /// still signs.
  Future<BiometricEnrolment> enrol() async {
    try {
      final publicKey = await _channel.invokeMethod<String>('enrol');

      if (publicKey == null || publicKey.isEmpty) {
        return const BiometricRefused(BiometricUnavailable.platformError);
      }

      return BiometricEnrolled(publicKey);
    } on PlatformException catch (error) {
      return BiometricRefused(
        _reason(error.code) ?? BiometricUnavailable.platformError,
        detail: error.message,
      );
    } on MissingPluginException {
      return const BiometricRefused(
        BiometricUnavailable.keyUnsupported,
        detail: 'No device key implementation on this platform yet.',
      );
    }
  }

  /// Shows the system prompt and signs [challenge] with the device key.
  ///
  /// The prompt is the gate: the key was created with `setUserAuthenticationRequired`,
  /// so the hardware itself refuses to sign until the sensor has confirmed the owner.
  /// Nothing here can skip that, which is the point — a boolean crossing this channel
  /// would prove nothing to a server.
  Future<BiometricSignature> sign(
    String challenge, {
    String title = 'Confirm it is you',
    String reason = 'Sign in to HAAT',
    String negative = 'Use another method',
  }) async {
    try {
      final signature = await _channel.invokeMethod<String>('sign', {
        'challenge': challenge,
        'title': title,
        'reason': reason,
        'negative': negative,
      });

      if (signature == null || signature.isEmpty) {
        return const BiometricSignRefused(BiometricUnavailable.platformError);
      }

      return BiometricSigned(signature);
    } on PlatformException catch (error) {
      return BiometricSignRefused(
        _reason(error.code) ?? BiometricUnavailable.platformError,
        detail: error.message,
      );
    } on MissingPluginException {
      return const BiometricSignRefused(BiometricUnavailable.keyUnsupported);
    }
  }

  /// Destroys the device key.
  ///
  /// The local half of turning biometrics off. The server enrolment is removed
  /// separately — both have to go, and this one is the half that stops working
  /// immediately.
  Future<void> remove() async {
    try {
      await _channel.invokeMethod<bool>('remove');
    } catch (_) {
      // Nothing to do and nothing to report. A key that could not be deleted is still
      // useless once the server forgets its public half.
    }
  }

  /// What to tell the user, for each reason it did not work.
  static String describe(BiometricUnavailable reason) => switch (reason) {
        BiometricUnavailable.noHardware =>
          'This device does not support biometric sign-in.',
        BiometricUnavailable.notEnrolled =>
          'Add a fingerprint or face in your device settings first.',
        BiometricUnavailable.cancelled => 'Biometric sign-in was cancelled.',
        BiometricUnavailable.keyInvalidated =>
          'Your fingerprint or face has changed, so biometric sign-in was turned off. '
              'You can set it up again from settings.',
        BiometricUnavailable.keyUnsupported =>
          'Biometric sign-in is not ready yet. You can use your passcode for now.',
        BiometricUnavailable.platformError =>
          'We could not set up biometrics on this device.',
      };

  /// The native side's code, as the reason it stands for. Null means success.
  static BiometricUnavailable? _reason(String? code) => switch (code) {
        null => null,
        'no_hardware' => BiometricUnavailable.noHardware,
        'not_enrolled' => BiometricUnavailable.notEnrolled,
        'cancelled' => BiometricUnavailable.cancelled,
        'key_invalidated' => BiometricUnavailable.keyInvalidated,
        'key_unsupported' => BiometricUnavailable.keyUnsupported,
        _ => BiometricUnavailable.platformError,
      };
}
