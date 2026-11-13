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

/// Replaces the account password. Empty means it worked.
///
/// The server checks [currentPassword] before it accepts [newPassword], and a
/// wrong one comes back as its own message for the sheet to show.
Future<String> haatChangePassword(
  String currentPassword,
  String newPassword,
) async {
  final session = AuthSession.instance;

  return HaatResult.messageOrEmpty(
    await session.setPassword(newPassword, currentPassword: currentPassword),
    session.languageCode,
  );
}
