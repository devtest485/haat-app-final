// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:blink_kyc/blink_kyc.dart';
import 'package:google_fonts/google_fonts.dart';

/// Which documents the provider accepts, and what to call them.
///
/// ## Why this list, and why it is fragile
///
/// These are the three the provider accepts, read off its own hosted chooser.
/// Anything outside the set is refused with "this document does not match your
/// selection" — so an ID card, which the SDK's enum offers, is not here.
///
/// It is a copy of a setting held in the provider's account, and it has already
/// been seen to change: the same page offered two types one day and three the
/// next. The session knows the allowed set — the SDK's documentation says it
/// reads the session policy on `run()` — but nothing exposes it. `StatusView`
/// carries the status, the current step and the steps completed, and no list of
/// documents. So this is maintained by hand, and it is wrong the day the account
/// is reconfigured.
///
/// **The country is not ours to choose.** It is fixed on the provider's account,
/// and `document()` takes no country — the parameter their documentation
/// describes does not exist in any released version. A document issued anywhere
/// else is refused however well the type matches, which is worth knowing before
/// blaming the capture.
const List<({DocumentType type, String name, String label, String detail})>
    _documents = [
  (
    type: DocumentType.passport,
    name: 'passport',
    label: 'Passport',
    detail: 'The photo page',
  ),
  (
    type: DocumentType.nationalId,
    name: 'nationalId',
    label: 'National ID',
    detail: 'Both sides, front first',
  ),
  (
    type: DocumentType.drivingLicence,
    name: 'drivingLicence',
    label: 'Driving licence',
    detail: 'Both sides, front first',
  ),
];

/// Asks which document the merchant is holding, and remembers the answer.
///
/// Asked because the provider checks the capture against whatever type it was
/// told to expect and refuses anything else — "this document does not match your
/// selection". Hard-coding a national ID meant a merchant holding a passport was
/// refused for presenting the right document.
///
/// The SDK has no chooser of its own. Its documentation describes one, and a
/// `country:` parameter to go with it, but neither exists in any released
/// version — `document()` still takes only a type and a side. Omitting the type
/// does not help either: the server then assumes a national ID.
///
/// Called before the session is opened rather than after. A session is a paid
/// thing, and a merchant who opens this and changes their mind should not have
/// spent one.
///
/// Returns the SDK's own name for the document, or null if they closed it.
Future<String?> chooseKycDocument(
    BuildContext context, String? previous) async {
  final chosen = await _chooseDocument(context, previous);

  if (chosen == null || !context.mounted) return null;

  FFAppState().update(() => FFAppState().kycDocumentType = chosen.name);

  return chosen.name;
}

/// Photographs the documents, offering another go when one is refused.
///
/// [documentType] is what [chooseKycDocument] returned. The question is not asked
/// again here: a refused photograph is a reason to take another photograph, not a
/// reason to doubt which document is in the merchant's hand.
Future<String> runKycCapture(
  BuildContext context,
  String baseUrl,
  String sessionToken,
  String? documentType,
) async {
  final chosen = _documents.firstWhere(
    (document) => document.name == documentType,
    // Only reachable if the choice went missing between the sheet and here. The
    // national ID is what every capture used before the question was asked at
    // all, so it is the least surprising thing to fall back to.
    orElse: () => _documents[1],
  );

  // ## Why this is a loop
  //
  // A refused photograph used to end the whole attempt. The merchant was
  // returned to the screen, and tapping the button again opened a **new**
  // session — so a blurred first try became a second session, a third, a fourth.
  // One tester needed six before one went through, and six sessions is what the
  // records show.
  //
  // Retrying inside the loop reuses the session that is already open, so a bad
  // photograph costs another photograph rather than another session. If the
  // provider will not accept a second attempt on a spent session it says so, and
  // that arrives as a `BlinkError` below, which already tells the merchant to
  // start again.
  while (true) {
    try {
      await BlinkKyc(baseUrl, sessionToken)
          .document(type: chosen.type)
          .face()
          .present(context)
          .run();

      return 'OK';
    } on BlinkStepError catch (error) {
      if (!context.mounted) return 'CANCELLED';

      // The provider writes these for the person holding the phone — "take a
      // clearer photo showing the entire document" — and that is more use than
      // anything we could say from here, which would only be vaguer.
      //
      // Asked rather than retried silently: the camera reopening on its own,
      // immediately after a refusal, reads as a crash rather than an offer.
      final again = await _offerRetry(context, error.message);

      if (again != true || !context.mounted) return 'CANCELLED';
    } on BlinkError catch (error) {
      // Backing out of the camera is a choice, not a fault, and saying
      // "verification failed" to somebody who pressed close is how a screen
      // loses trust.
      if (error.code == BlinkErrorCode.cancelled) return 'CANCELLED';

      return _captureFailure(error);
    } catch (_) {
      return 'The verification could not be completed. You can try again.';
    }
  }
}

/// What to say about a transport failure, in words that suggest what to do next.
///
/// The provider's own wording names its internals — session, challenge, origin —
/// which tells a merchant nothing they can act on. So the codes that have a
/// remedy get one, and the rest fall back to plain "try again".
String _captureFailure(BlinkError error) => switch (error.code) {
      BlinkErrorCode.cameraDenied =>
        'HAAT needs camera access to check your ID. Allow it in your phone '
            'settings, then try again.',
      BlinkErrorCode.cameraUnavailable =>
        'The camera is not available. Close anything else using it, then try '
            'again.',
      BlinkErrorCode.network ||
      BlinkErrorCode.timeout =>
        'We could not reach the verification service. Check your connection '
            'and try again.',
      BlinkErrorCode.sessionExpired ||
      BlinkErrorCode.sessionSpent ||
      BlinkErrorCode.sessionInvalid =>
        'That attempt has expired. Tap Start Verification to begin a new one.',
      BlinkErrorCode.quotaExceeded =>
        'Verification is unavailable at the moment. Please try again later.',
      _ => 'The verification could not be completed. You can try again.',
    };

/// Which document the merchant is holding. Null when they closed the sheet.
Future<({DocumentType type, String name})?> _chooseDocument(
  BuildContext context,
  String? previous,
) =>
    _ask<({DocumentType type, String name})>(
      context,
      title: 'Which document?',
      message:
          'Pick the one you are holding, so we check it against the right thing.',
      options: [
        for (final document in _documents)
          (
            value: (type: document.type, name: document.name),
            label: document.label,
            detail: document.detail,
            highlighted: document.name == previous,
          ),
      ],
    );

/// Offers another photograph after the provider refused one.
///
/// The provider's own sentence is the question's body, because it says what to
/// change — a clearer photo, the whole document in frame — and repeating it as a
/// bare failure with an OK button would throw that away and send the merchant
/// back to the start.
Future<bool?> _offerRetry(BuildContext context, String reason) => _ask<bool>(
      context,
      title: 'Try that again?',
      message: reason,
      options: const [
        (
          value: true,
          label: 'Take another photo',
          detail: 'Reopens the camera on the same check',
          highlighted: true,
        ),
        (value: false, label: 'Not now', detail: null, highlighted: false),
      ],
    );

/// A bottom sheet that asks one question and returns the answer.
///
/// A sheet rather than a `SnackBar` because both questions have to be answered
/// before anything else can happen, and rather than a page because the camera is
/// mid-flight — a route change here would tear down the capture that is about to
/// resume.
///
/// Dismissible, and dismissal is an answer: closing the document sheet means the
/// merchant is not ready, and closing the retry sheet means they have had enough.
/// Both come back as null and stop the attempt without saying anything.
Future<T?> _ask<T>(
  BuildContext context, {
  required String title,
  required String message,
  required List<({T value, String label, String? detail, bool highlighted})>
      options,
}) {
  final theme = FlutterFlowTheme.of(context);

  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: theme.primaryBackground,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) => SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(20, 20, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.headlineSmall.override(
                font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                color: theme.primaryText,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.bodyMedium.override(
                font: GoogleFonts.inter(),
                color: theme.secondaryText,
              ),
            ),
            const SizedBox(height: 20),
            for (final option in options) ...[
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.of(sheetContext).pop(option.value),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 14, 16, 14),
                  decoration: BoxDecoration(
                    color: const Color(0x0EFFFFFF),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: option.highlighted
                          ? theme.primaryText
                          : const Color(0xFF292E38),
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        option.label,
                        style: theme.bodyMedium.override(
                          font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                          color: theme.primaryText,
                          fontSize: 16,
                        ),
                      ),
                      if (option.detail != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          option.detail!,
                          style: theme.bodySmall.override(
                            font: GoogleFonts.inter(),
                            color: theme.secondaryText,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ],
        ),
      ),
    ),
  );
}
