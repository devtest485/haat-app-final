// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/backend/api/haat_result.dart';
import '/backend/auth/auth_session.dart';

/// Signs in with the passcode, on a device that already has a session.
///
/// Verified by the server, not compared on the phone: a passcode checked locally
/// is a passcode anybody holding the handset can change.
/// Nullable for the same reason as [haatSetPasscode]: the keypad's page state
/// is a String? and FlutterFlow passes it through unchanged.
Future<String> haatSignInWithPasscode(String? passcode) async {
  final session = AuthSession.instance;

  return HaatResult.messageOrEmpty(
    await session.signInWithPasscode(passcode ?? ''),
    session.languageCode,
  );
}
