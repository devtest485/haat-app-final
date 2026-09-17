// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/backend/auth/auth_session.dart';
import '/backend/auth/biometric_key_store.dart';

/// Enrols this device's key and registers its public half. Empty means it worked.
///
/// Cancelling is not a failure — the screen offers biometrics, it does not
/// require them — so a dismissed prompt returns `CANCELLED` for the page to pass
/// over quietly rather than a message to put in front of somebody.
Future<String> haatEnableBiometrics() async {
  final enrolment = await AuthSession.instance.enableBiometrics();

  if (enrolment is BiometricEnrolled) return '';

  final refused = enrolment as BiometricRefused;

  return switch (refused.reason) {
    BiometricUnavailable.cancelled => 'CANCELLED',
    BiometricUnavailable.noHardware =>
      'This phone has no fingerprint or face sensor we can use.',
    BiometricUnavailable.notEnrolled =>
      'Add a fingerprint or face to this phone first, then try again.',
    BiometricUnavailable.keyInvalidated =>
      'Your biometrics changed, so the old key no longer works. Set it up again.',
    BiometricUnavailable.keyUnsupported =>
      'Biometric sign-in is not available on this device yet.',
    BiometricUnavailable.platformError =>
      refused.detail ?? 'We could not set up biometric sign-in. You can try again.',
  };
}
