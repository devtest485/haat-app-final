// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/api_result.dart';
import '/custom_code/auth_session.dart';
import '/custom_code/biometric_key_store.dart';
import '/custom_code/transfer_api.dart';

/// Approves one transfer with this phone's fingerprint.
///
/// Returns `{signature}` to send with the transfer, or `{error}` — a sentence for the
/// sheet, empty when they cancelled to type the passcode instead.
///
/// A phone without a key, a key the server never registered, or one the phone threw
/// away when its fingerprints changed: each is set up again here, once, exactly as
/// turning fingerprint on in Security would, and the approval carries on.
Future<dynamic> haatTransferFingerprint(
  String? by,
  String? value,
  String? amountMinor,
  String? currency,
  String? transferReference,
  String? amountText,
  String? name,
) async {
  final session = AuthSession.instance;

  String refusal(BiometricUnavailable reason, {bool resignIn = false}) =>
      switch (reason) {
        // They chose the passcode: nothing went wrong.
        BiometricUnavailable.cancelled => '',
        _ when resignIn =>
          'Sign out and in again to use fingerprint on this phone. Use your passcode for now.',
        BiometricUnavailable.keyInvalidated =>
          'The fingerprints on this phone changed. Use your passcode, then turn fingerprint on again in Security.',
        BiometricUnavailable.notEnrolled ||
        BiometricUnavailable.noHardware =>
          'No fingerprint is set up on this phone. Use your passcode.',
        _ => 'Fingerprint isn’t available right now. Use your passcode.',
      };

  final minor = BigInt.tryParse(amountMinor ?? '');
  if (minor == null) {
    return {'error': refusal(BiometricUnavailable.platformError)};
  }

  var enrolled = false;
  Future<String?> enrol() async {
    enrolled = true;
    final enrolment = await session.enableBiometrics();
    if (enrolment is BiometricEnrolled) return null;
    return enrolment is BiometricRefused
        ? refusal(enrolment.reason, resignIn: enrolment.detail != null)
        : refusal(BiometricUnavailable.platformError);
  }

  if (!await session.hasBiometricKey()) {
    final error = await enrol();
    if (error != null) return {'error': error};
  }

  while (true) {
    final challenge = await session.transfers.challenge(
      by: by == 'mobile' ? TransferBy.mobile : TransferBy.username,
      value: value ?? '',
      amountMinor: minor,
      currency: currency ?? 'SDG',
      reference: transferReference ?? '',
    );
    if (challenge is ApiFailure<String> &&
        challenge.data['field'] == 'biometric' &&
        !enrolled) {
      final error = await enrol();
      if (error != null) return {'error': error};
      continue;
    }
    if (challenge is! ApiSuccess<String> || challenge.value.isEmpty) {
      return {'error': challenge.messageIn('en')};
    }

    final signed = await session.biometrics.sign(
      challenge.value,
      title: 'Confirm transfer',
      reason: 'Send ${amountText ?? ''} to ${name ?? ''}',
      negative: 'Use passcode',
    );
    if (signed is BiometricSigned) return {'signature': signed.signature};

    final reason = signed is BiometricSignRefused
        ? signed.reason
        : BiometricUnavailable.platformError;
    if (reason == BiometricUnavailable.keyInvalidated && !enrolled) {
      final error = await enrol();
      if (error != null) return {'error': error};
      continue;
    }
    return {'error': refusal(reason)};
  }
}
