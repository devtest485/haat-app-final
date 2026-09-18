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

/// Runs identity verification end to end, and returns what happened as one word.
///
/// Three steps, because the app never reads the verdict from the SDK: open a
/// session on the backend, let the SDK drive the camera, then ask the backend
/// what the provider concluded. The SDK's own documentation is blunt about it —
/// act on the verdict your backend fetches, not the copy the app reports.
///
/// [documentType] is only the answer the merchant gave last time, used to mark
/// it in the sheet that asks again before anything else happens. A refused
/// photograph is then handled inside the capture without spending the session —
/// see `runKycCapture`.
///
/// Whichever document is used reaches the SDK and nothing else:
/// `POST /kyc/user/provider-session` takes no body, so the backend neither knows
/// nor needs to know which one was chosen; it reads the provider's verdict either
/// way. That is also why a failed attempt can simply be run again with a
/// different document — there is no server-side state tied to the first choice.
///
/// ## Why a word rather than a sentence
///
/// This returned the sentence to show, and the page matched `REJECTED` against
/// it to decide whether to offer another attempt. Everything else — a provider
/// that refused to open a session, a camera the merchant never granted, a
/// verdict that had not landed yet — came back as prose the page could not tell
/// apart from success, so it said the words and moved the merchant on. A
/// verification that did not happen looked exactly like one that did.
///
/// So the outcome and the wording are two things now. The outcome is one of
/// [kycVerified], [kycReview], [kycRejected], [kycPending], [kycCancelled],
/// [kycFailed] or [kycUnavailable]; the sentence, when there is one, is left in
/// `FFAppState().kycMessage` for the page to show.
Future<String> haatRunKyc(BuildContext context, String documentType) async {
  final session = AuthSession.instance;

  Future<String> outcome(String result, [String message = '']) async {
    FFAppState().update(() => FFAppState().kycMessage = message);

    return result;
  }

  // Asked before the session is opened. A session is a paid thing and the
  // provider spends one the moment it is created, so a merchant who opens the
  // sheet and thinks better of it should not have cost anything.
  final document = await chooseKycDocument(context, documentType);

  if (document == null || !context.mounted) return outcome(kycCancelled);

  final opened = await session.kyc.startSession();

  if (opened is! ApiSuccess<KycProviderSession>) {
    // Automated verification being switched off in the back office is the one
    // refusal to move past rather than report. Nothing is broken and retrying
    // will not help — an operator turned the paid check off, and the merchant
    // carries on to the manual path without being told about a setting that is
    // none of their concern.
    if (opened.errorCode == ApiErrorCode.kycProviderDisabled) {
      return outcome(kycUnavailable);
    }

    return outcome(kycFailed, opened.messageIn(session.languageCode));
  }

  final capture = await runKycCapture(
    context,
    opened.value.baseUrl,
    opened.value.sessionToken,
    document,
  );

  // Backing out of the camera is a choice, not a failure, and nothing is said
  // about it.
  if (capture == 'CANCELLED') return outcome(kycCancelled);
  if (capture != 'OK') return outcome(kycFailed, capture);

  final collected = await session.kyc.collectResult();
  if (collected is! ApiSuccess<KycProviderOutcome>) {
    return outcome(kycFailed, collected.messageIn(session.languageCode));
  }

  return switch (collected.value.result) {
    'VERIFIED' => outcome(kycVerified, 'Your identity is verified.'),
    'REVIEW' => outcome(
        kycReview,
        'Your documents are with our team for a closer look.',
      ),
    'REJECTED' => outcome(
        kycRejected,
        'We could not verify those documents. Try again, or verify with a '
        'different one.',
      ),
    _ => outcome(
        kycPending,
        'That attempt did not come back with an answer. Please try again.',
      ),
  };
}

/// The provider is satisfied.
const String kycVerified = 'VERIFIED';

/// Sent for a human to look at — an answer, just not an automatic one.
const String kycReview = 'REVIEW';

/// The documents were refused. Worth another attempt, and often with a
/// different document.
const String kycRejected = 'REJECTED';

/// No verdict came back. Not a refusal, but not a pass either, so it is not
/// something to carry the merchant past — the attempt simply has to be made
/// again.
const String kycPending = 'PENDING';

/// The merchant closed the camera. Nothing to say and nowhere to go.
const String kycCancelled = 'CANCELLED';

/// Something went wrong before a verdict could exist: the session, the camera,
/// the network. `kycMessage` says which.
const String kycFailed = 'FAILED';

/// Automated verification is switched off for this platform. Nothing is wrong
/// and there is nothing to retry.
const String kycUnavailable = 'UNAVAILABLE';
