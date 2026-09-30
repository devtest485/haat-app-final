// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/auth_session.dart';
import '/custom_code/biometric_key_store.dart';

/// Signs in with the fingerprint. Empty means it worked and the session is open.
///
/// Two codes come back instead of a message, for the page to branch on:
///
/// - `CANCELLED` — no signature. The owner dismissed the prompt, or the screen
///   raised it by itself and something quiet went wrong. Nothing to say.
/// - `NOT_ENROLLED` — the server has no key for this handset any more (revoked
///   from another phone, or this install is not the one that enrolled). The page
///   hides the option; the password still works.
///
/// [automatic] is true when the screen raised the prompt on arrival rather than
/// on a tap. A refusal nobody asked about is not worth a message — except a
/// refused signature, which follows the owner putting their finger on the sensor
/// and watching nothing happen, and a key the phone destroyed, which makes the
/// option vanish and would otherwise look like a bug.
Future<String> haatSignInWithBiometrics(bool automatic) async {
  final session = AuthSession.instance;
  final outcome = await session.signInWithBiometrics();

  return switch (outcome) {
    BiometricSignedIn() => '',
    BiometricPromptRefused(reason: BiometricUnavailable.keyInvalidated) =>
      BiometricKeyStore.describe(BiometricUnavailable.keyInvalidated),
    BiometricPromptRefused(:final reason) =>
      automatic || reason == BiometricUnavailable.cancelled
          ? 'CANCELLED'
          : BiometricKeyStore.describe(reason),
    BiometricNotEnrolled() => 'NOT_ENROLLED',
    BiometricSignatureRefused(:final result) =>
      result.messageIn(session.languageCode),
  };
}
