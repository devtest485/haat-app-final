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

/// Claims the handle. Empty means it worked.
Future<String> haatClaimUsername(String username) async {
  final session = AuthSession.instance;

  return HaatResult.messageOrEmpty(
    await session.claimUsername(username),
    session.languageCode,
  );
}
