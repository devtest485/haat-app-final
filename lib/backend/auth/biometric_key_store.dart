import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:local_auth/local_auth.dart';

/// Why enabling biometrics did not happen.
enum BiometricUnavailable {
  /// The handset has no fingerprint reader or face sensor.
  noHardware,

  /// It has the hardware, but the owner has not enrolled a fingerprint or face.
  notEnrolled,

  /// The user dismissed the prompt.
  cancelled,

  /// The device key could not be created — see [BiometricKeyStore] for why this is
  /// currently the usual answer.
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

/// Biometric sign-in, as far as the platform lets us take it.
///
/// ## What the backend expects, and why this is not finished
///
/// `POST /auth/biometric` takes the public half of a **P-256 key pair generated inside
/// the phone's secure hardware** — the Android Keystore's TEE or StrongBox, or the iOS
/// Secure Enclave — and `/auth/biometric/verify` takes an ES256 signature over a
/// single-use challenge the server issued. The security property is that the private
/// key physically cannot leave that hardware, so a signature proves the request came
/// from this handset with its owner's fingerprint on the sensor.
///
/// `local_auth`, the Flutter plugin used here, does not do that. It shows the system
/// prompt and reports a boolean. A boolean crossing a platform channel proves nothing
/// to a server: anything that can call the plugin can also just return true.
///
/// So the honest position is:
///
/// - [availability] and [authenticate] work now, and are enough for the screen to behave
///   sensibly — not offering "Enable" on a handset with no sensor, and confirming the
///   owner is present.
/// - [enrol] returns [BiometricRefused] with [BiometricUnavailable.keyUnsupported],
///   because the keystore work is Kotlin and Swift that has not been written.
///
/// **It deliberately does not generate a key in Dart and send that.** A private key
/// sitting in the app's own storage is a key that can be copied off a rooted device,
/// which removes the entire reason the endpoint is designed this way — and it would
/// look finished while being worth less than no biometrics at all.
///
/// ## What finishing it needs
///
/// A platform channel with two implementations:
///
/// - **Android** — `KeyPairGenerator.getInstance("EC", "AndroidKeyStore")` with a
///   `KeyGenParameterSpec` that sets `setUserAuthenticationRequired(true)`,
///   `setDigests(DIGEST_SHA256)` and P-256, then `Signature.getInstance("SHA256withECDSA")`
///   to sign the challenge.
/// - **iOS** — `SecKeyCreateRandomKey` with `kSecAttrTokenIDSecureEnclave` and an access
///   control of `biometryCurrentSet`, then `SecKeyCreateSignature` with
///   `ecdsaSignatureMessageX962SHA256`.
///
/// Both return the SPKI public key on enrolment and a base64 signature on each sign-in,
/// which is exactly what the two endpoints already accept.
class BiometricKeyStore {
  BiometricKeyStore({LocalAuthentication? auth})
      : _auth = auth ?? LocalAuthentication();

  final LocalAuthentication _auth;

  /// Whether this handset can do biometrics at all, and has something enrolled.
  Future<BiometricUnavailable?> availability() async {
    // The plugin has no web implementation, so asking would raise
    // MissingPluginException rather than answering.
    if (kIsWeb) return BiometricUnavailable.noHardware;

    try {
      if (!await _auth.isDeviceSupported()) return BiometricUnavailable.noHardware;
      if (!await _auth.canCheckBiometrics) return BiometricUnavailable.noHardware;

      final enrolled = await _auth.getAvailableBiometrics();
      if (enrolled.isEmpty) return BiometricUnavailable.notEnrolled;

      return null;
    } catch (_) {
      // Caught broadly on purpose. Besides PlatformException this can raise
      // MissingPluginException, which is not one — and a handset that cannot answer
      // the question is indistinguishable, from here, from one that says no.
      return BiometricUnavailable.platformError;
    }
  }

  /// Shows the system prompt and reports whether the owner passed it.
  ///
  /// Useful as a local gate — confirming the person holding the phone before revealing
  /// something — and not useful as proof to the server. See the class comment.
  Future<bool> authenticate({required String reason}) async {
    if (kIsWeb) return false;

    try {
      return await _auth.authenticate(
        localizedReason: reason,
        options: const AuthenticationOptions(
          biometricOnly: true,
          // Keeps the prompt up when the app briefly loses focus, which some handsets
          // do while the sensor reads.
          stickyAuth: true,
        ),
      );
    } catch (_) {
      // A dismissed prompt, a missing plugin and a locked-out sensor all mean the same
      // thing to the caller: the owner was not confirmed.
      return false;
    }
  }

  /// Creates a device-bound key pair and returns its public half.
  ///
  /// Always [BiometricRefused] for now — the keystore implementation described in the
  /// class comment does not exist yet, and inventing a key in Dart would defeat the
  /// design rather than complete it.
  Future<BiometricEnrolment> enrol() async {
    final unavailable = await availability();
    if (unavailable != null) return BiometricRefused(unavailable);

    return const BiometricRefused(
      BiometricUnavailable.keyUnsupported,
      detail: 'Device key generation is not implemented on this platform yet.',
    );
  }

  /// Signs a server challenge with the device key.
  ///
  /// Unreachable while [enrol] never succeeds, and present so the calling code is
  /// written against the finished shape.
  Future<String?> sign(String challenge) async => null;

  /// What to tell the user, for each reason it did not work.
  static String describe(BiometricUnavailable reason) => switch (reason) {
        BiometricUnavailable.noHardware =>
          'This device does not support biometric sign-in.',
        BiometricUnavailable.notEnrolled =>
          'Add a fingerprint or face in your device settings first.',
        BiometricUnavailable.cancelled => 'Biometric setup was cancelled.',
        BiometricUnavailable.keyUnsupported =>
          'Biometric sign-in is not ready yet. You can use your passcode for now.',
        BiometricUnavailable.platformError =>
          'We could not set up biometrics on this device.',
      };
}
