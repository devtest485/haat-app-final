// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/haat_result.dart';
import '/custom_code/auth_session.dart';

/// Gets past the passcode screen. Empty means it worked.
///
/// The same keypad serves two cases. With a session already on the phone, the
/// passcode unlocks it. After a sign-out there is no session, and the passcode
/// signs in — together with the secret this handset was given while it was
/// signed in, never on its own.
///
/// Verified by the server, not compared on the phone: a passcode checked locally
/// is a passcode anybody holding the handset can change.
/// Nullable for the same reason as [haatSetPasscode]: the keypad's page state
/// is a String? and FlutterFlow passes it through unchanged.
Future<String> haatSignInWithPasscode(String? passcode) async {
  final session = AuthSession.instance;

  if (session.isSignedIn) {
    return HaatResult.messageOrEmpty(
      await session.unlockWithPasscode(passcode ?? ''),
      session.languageCode,
    );
  }

  return HaatResult.messageOrEmpty(
    await session.signInWithPasscode(passcode ?? ''),
    session.languageCode,
  );
}
