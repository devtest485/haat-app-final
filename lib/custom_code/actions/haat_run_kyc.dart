// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/api_envelope.dart';
import '/custom_code/api_result.dart';
import '/custom_code/kyc_api.dart';
import '/custom_code/auth_session.dart';
import '/custom_code/actions/run_kyc_capture.dart';

/// Runs identity verification end to end, and returns what to tell the user.
///
/// Three steps, because the app never reads the verdict from the SDK: open a
/// session on the backend, let the SDK drive the camera, then ask the backend
/// what the provider concluded. The SDK's own documentation is blunt about it —
/// act on the verdict your backend fetches, not the copy the app reports.
///
/// The document is the merchant's choice, carried in from the screen that asked.
/// It reaches the SDK and nothing else — `POST /kyc/user/provider-session` takes
/// no body, so the backend neither knows nor needs to know which one was used;
/// it reads the provider's verdict either way. That is also why a failed attempt
/// can simply be run again with a different document: there is no server-side
/// state tied to the first choice.
///
/// Returns `CANCELLED` when the person backed out, which is not a failure and
/// nothing should be said about it. Empty means carry on without a message.
/// `REJECTED` means the documents were refused and another attempt is worth
/// offering. Anything else is text to show before carrying on.
Future<String> haatRunKyc(BuildContext context, String documentType) async {
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
    documentType,
  );
  if (capture != 'OK') return capture;

  final collected = await session.kyc.collectResult();
  if (collected is! ApiSuccess<KycProviderOutcome>) {
    return collected.messageIn(session.languageCode);
  }

  return switch (collected.value.result) {
    'VERIFIED' => 'Your identity is verified.',
    'REVIEW' => 'Your documents are with our team for a closer look.',
    // The one verdict the screen acts on rather than just reports. Returned as
    // a word, not a sentence, for the same reason CANCELLED is: an action chain
    // can branch on it, and the wording that goes on screen then lives in one
    // place instead of being matched against.
    'REJECTED' => 'REJECTED',
    _ => 'Your verification is still being processed.',
  };
}
