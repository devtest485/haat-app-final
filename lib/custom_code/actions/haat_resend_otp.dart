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

/// Issues a new one-time code for the number registration is waiting on.
///
/// The number is not a parameter: the session remembers it, so a resend still
/// works after the app has been backgrounded.
Future<String> haatResendOtp() async {
  final session = AuthSession.instance;

  return HaatResult.messageOrEmpty(
    await session.resendOtp(),
    session.languageCode,
  );
}
