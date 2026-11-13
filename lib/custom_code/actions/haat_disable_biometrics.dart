// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/haat_result.dart';
import '/custom_code/auth_session.dart';

/// Turns biometric sign-in off on this phone. Empty means it worked.
///
/// The device key is gone even when the server could not be reached, so the
/// switch can show off either way; the message only says the server still has
/// to be told.
Future<String> haatDisableBiometrics() async {
  final session = AuthSession.instance;
  final removed = await session.disableBiometrics();

  if (removed == null) return '';

  return HaatResult.messageOrEmpty(removed, session.languageCode);
}
