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

/// Sets the six-digit passcode. Empty means it worked.
///
/// Nullable because FlutterFlow page state is: the keypad writes into a String?
/// and the generated call passes it straight through, so a non-null parameter
/// here fails to compile on the page rather than here.
Future<String> haatSetPasscode(String? passcode) async {
  final session = AuthSession.instance;

  return HaatResult.messageOrEmpty(
    await session.setPasscode(passcode ?? ''),
    session.languageCode,
  );
}
