// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/backend/api/api_envelope.dart';
import '/backend/api/api_result.dart';
import '/backend/api/kyc_api.dart';
import '/backend/auth/auth_session.dart';
import '/custom_code/actions/run_kyc_capture.dart';

/// Runs identity verification end to end, and returns what to tell the user.
///
/// Three steps, because the app never reads the verdict from the SDK: open a
/// session on the backend, let the SDK drive the camera, then ask the backend
/// what the provider concluded. The SDK's own documentation is blunt about it —
/// act on the verdict your backend fetches, not the copy the app reports.
///
/// Returns `CANCELLED` when the person backed out, which is not a failure and
/// nothing should be said about it. Empty means carry on without a message.
/// Anything else is text to show before carrying on.
Future<String> haatRunKyc(BuildContext context) async {
  final session = AuthSession.instance;
  final opened = await session.kyc.startSession();

  if (opened is! ApiSuccess<KycProviderSession>) {
    // Automated verification being switched off in the back office is the one
    // refusal to move past rather than report. Nothing is broken and retrying
    // will not help — an operator turned the paid check off, and the merchant
    // carries on to the manual path without being told about a setting that is
    // none of their concern.
    if (opened.errorCode == ApiErrorCode.kycProviderDisabled) return '';

    return opened.messageIn(session.languageCode);
  }

  final capture = await runKycCapture(
    context,
    opened.value.baseUrl,
    opened.value.sessionToken,
  );
  if (capture != 'OK') return capture;

  final collected = await session.kyc.collectResult();
  if (collected is! ApiSuccess<KycProviderOutcome>) {
    return collected.messageIn(session.languageCode);
  }

  return switch (collected.value.result) {
    'VERIFIED' => 'Your identity is verified.',
    'REVIEW' => 'Your documents are with our team for a closer look.',
    'REJECTED' => 'We could not verify those documents. You can try again.',
    _ => 'Your verification is still being processed.',
  };
}
