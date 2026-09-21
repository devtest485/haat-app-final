// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/api_result.dart';
import '/custom_code/auth_session.dart';
import '/custom_code/kyc_api.dart';

/// Hands the business's documents to the back office.
///
/// Empty when the case is on its way — or was already sent, which is the same answer
/// to the person tapping Continue.
///
/// Anything else is the server's own sentence, and the one that matters is the refusal
/// for an incomplete case: it names the document still missing. A merchant told only
/// that their submission is incomplete sends the same files again.
Future<String> haatSubmitKyb() async {
  final session = AuthSession.instance;
  final result = await session.kyc.submitBusinessCase();

  if (result is ApiSuccess<KycCase>) return '';

  // Already with the back office: the merchant did what the screen asked, and the
  // screen should let them past rather than report a conflict they cannot act on.
  if (result.errorCode == 'CONFLICT') return '';

  return result.messageIn(session.languageCode);
}
