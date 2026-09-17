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

/// Verifies the one-time code and adopts the session it returns.
///
/// Empty means it worked; the page then asks [haatStartupRoute] where to go,
/// because what comes next depends on what the account already has set up.
/// [code] is nullable because FlutterFlow page state is: the OTP field writes
/// into a String? and the generated call passes it straight through, so a
/// non-null parameter here fails to compile on the page rather than here.
Future<String> haatVerifyOtp(String? code) async {
  final session = AuthSession.instance;

  return HaatResult.messageOrEmpty(
    await session.verifyOtp(code: code ?? ''),
    session.languageCode,
  );
}
