import 'package:blink_kyc/blink_kyc.dart';

import '/backend/api/api_config.dart';
import '/backend/api/api_envelope.dart';
import '/backend/api/api_result.dart';
import '/backend/api/kyc_api.dart';
import '/backend/auth/auth_session.dart';
import '/backend/ui/api_feedback.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'verify_page_model.dart';
export 'verify_page_model.dart';

class VerifyPageWidget extends StatefulWidget {
  const VerifyPageWidget({super.key});

  static String routeName = 'VerifyPage';
  static String routePath = '/verifyPage';

  @override
  State<VerifyPageWidget> createState() => _VerifyPageWidgetState();
}

class _VerifyPageWidgetState extends State<VerifyPageWidget> {
  late VerifyPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => VerifyPageModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  // ── Actions ───────────────────────────────────────────────────────────────────

  /// Runs an identity check, then asks the backend what it amounted to.
  ///
  /// Three steps, and the order of them is the whole security argument:
  ///
  /// 1. The **backend** opens the session. It holds the provider's key and secret and
  ///    hands back only a short-lived token.
  /// 2. The **SDK** runs the capture. The photographs go from this handset straight to
  ///    the provider; they never pass through HAAT.
  /// 3. The **backend** reads the verdict. The SDK returns one too, and it is ignored —
  ///    a value that came through the device is a value the device could have changed.
  Future<void> _startVerification() async {
    if (_model.isVerifying) return;

    final feedback = ApiFeedback.of(context);

    safeSetState(() => _model.isVerifying = true);

    final opened = await AuthSession.instance.kyc.startSession();

    if (!mounted) return;

    if (opened is! ApiSuccess<KycProviderSession>) {
      safeSetState(() => _model.isVerifying = false);

      // Switched off in the back office. Nothing is wrong and nothing needs retrying,
      // so the merchant is moved along rather than shown a setting that is none of
      // their business — the documents they upload next are reviewed by a person.
      if (opened is ApiFailure<KycProviderSession> &&
          opened.envelope.errorCode == ApiErrorCode.kycProviderDisabled) {
        context.pushNamed(BusinessInfoWidget.routeName);

        return;
      }

      await feedback.show(opened);

      return;
    }

    final session = opened.value;

    // Asked before the camera opens, because the provider checks the capture against
    // whatever type it was told to expect and refuses anything else — "this document
    // does not match your selection". Hard-coding a national ID meant a merchant holding
    // a passport was refused for presenting the right document.
    //
    // The SDK has no chooser of its own. Its documentation describes one, and a
    // `country:` parameter to go with it, but neither exists in any released version —
    // 1.3.0 is the repository head and `document()` still takes only a type and a side.
    // Omitting the type does not help either: the server then assumes a national ID.
    final chosen = await _chooseDocument(feedback);

    if (!mounted) return;

    if (chosen == null) {
      safeSetState(() => _model.isVerifying = false);

      return;
    }

    // Everything the capture can throw has to land here. The provider raises
    // `BlinkStepError` for a document or a face it would not accept and `BlinkError`
    // for everything else — and either one escaping takes the whole screen down with
    // it, so the bare clause catches whatever the other two do not rather than
    // trusting that list to stay complete.
    String? failure;

    // ## Why this is a loop
    //
    // A refused photograph used to end the whole attempt. The merchant was returned to
    // this screen, and tapping the button again opened a **new** session — so a blurred
    // first try became a second session, a third, a fourth. One tester needed six before
    // one went through, and six sessions is what the records show.
    //
    // Retrying inside the loop reuses the session that is already open, so a bad
    // photograph costs another photograph rather than another session. If the provider
    // will not accept a second attempt on a spent session it says so, and that arrives
    // as a `BlinkError` below, which already tells the merchant to start again.
    while (true) {
      try {
        await BlinkKyc(session.baseUrl, session.sessionToken)
            .document(type: chosen)
            .face()
            .present(context)
            .run();

        failure = null;
        break;
      } on BlinkStepError catch (error) {
        if (!mounted) return;

        // The provider writes these for the person holding the phone — "take a clearer
        // photo showing the entire document" — and that is more use than anything we
        // could say from here, which would only be vaguer.
        final again = await _offerRetry(feedback, error.message);

        if (!mounted) return;

        if (again != true) {
          safeSetState(() => _model.isVerifying = false);

          return;
        }
      } on BlinkError catch (error) {
        // Backing out of the camera is a choice, not a fault, and saying "verification
        // failed" to somebody who pressed close is how a screen loses trust.
        if (error.code == BlinkErrorCode.cancelled) {
          if (!mounted) return;
          safeSetState(() => _model.isVerifying = false);

          return;
        }

        failure = _captureFailure(error);
        break;
      } catch (_) {
        failure = 'The verification could not be completed. You can try again.';
        break;
      }
    }

    if (!mounted) return;

    if (failure != null) {
      safeSetState(() => _model.isVerifying = false);
      await feedback.notice(failure, isError: true);

      // Deliberately no verdict call: nothing was finalised, so there is nothing to
      // collect. The screen stays where it is and the button works again.
      return;
    }

    // The authoritative answer. Asked for after the capture, because the provider has
    // no webhook to tell anyone it finished.
    final collected = await AuthSession.instance.kyc.collectResult();

    if (!mounted) return;
    safeSetState(() => _model.isVerifying = false);

    if (collected is! ApiSuccess<KycProviderOutcome>) {
      await feedback.show(collected);

      return;
    }

    await feedback.notice(
      switch (collected.value.result) {
        'VERIFIED' => 'Your identity is verified.',
        'REVIEW' => 'Your documents are with our team for a closer look.',
        'REJECTED' => 'We could not verify those documents. You can try again.',
        _ => 'Your verification is still being processed.',
      },
      isError: collected.value.result == 'REJECTED',
    );

    if (!mounted) return;
    context.pushNamed(BusinessInfoWidget.routeName);
  }

  /// Which document the merchant is holding.
  ///
  /// ## Why this list, and why it is fragile
  ///
  /// These are the three the provider accepts, read off its own hosted chooser. Anything
  /// outside the set is refused with "this document does not match your selection".
  ///
  /// It is a copy of a setting held in the provider's account, and it has already been
  /// seen to change: the same page offered two types one day and three the next. The
  /// session knows the allowed set — the SDK's documentation says it reads the session
  /// policy on `run()` — but nothing exposes it. `StatusView` carries the status, the
  /// current step and the steps completed, and no list of documents. So this is
  /// maintained by hand, and it is wrong the day the account is reconfigured.
  ///
  /// **The country is not ours to choose.** It is fixed on the provider's account, and
  /// `document()` takes no country — the parameter their documentation describes does not
  /// exist in any released version. A document issued anywhere else is refused however
  /// well the type matches, which is worth knowing before blaming the capture.
  Future<DocumentType?> _chooseDocument(ApiFeedback feedback) =>
      feedback.choose<DocumentType>(
        title: 'Which document?',
        message: 'Pick the one you are holding, so we check it against the right thing.',
        options: const [
          (
            value: DocumentType.passport,
            label: 'Passport',
            detail: 'The photo page',
          ),
          (
            value: DocumentType.nationalId,
            label: 'National ID',
            detail: 'Both sides, front first',
          ),
          (
            value: DocumentType.drivingLicence,
            label: 'Driving licence',
            detail: 'Both sides, front first',
          ),
        ],
      );

  /// Offers another photograph after the provider refused one.
  ///
  /// The provider's own sentence is the question's body, because it says what to change
  /// — a clearer photo, the whole document in frame — and repeating it as a bare failure
  /// with an OK button would throw that away and send the merchant back to the start.
  ///
  /// Asked rather than retried silently: the camera reopening on its own, immediately
  /// after a refusal, reads as a crash rather than an offer.
  Future<bool?> _offerRetry(ApiFeedback feedback, String reason) =>
      feedback.choose<bool>(
        title: 'Try that again?',
        message: reason,
        options: const [
          (
            value: true,
            label: 'Take another photo',
            detail: 'Reopens the camera on the same check',
          ),
          (value: false, label: 'Not now', detail: null),
        ],
      );

  /// What to say about a transport failure, in words that suggest what to do next.
  ///
  /// The provider's own wording names its internals — session, challenge, origin —
  /// which tells a merchant nothing they can act on. So the codes that have a remedy
  /// get one, and the rest fall back to plain "try again".
  String _captureFailure(BlinkError error) => switch (error.code) {
        BlinkErrorCode.cameraDenied =>
          'HAAT needs camera access to check your ID. Allow it in your phone '
              'settings, then try again.',
        BlinkErrorCode.cameraUnavailable =>
          'The camera is not available. Close anything else using it, then try '
              'again.',
        BlinkErrorCode.network || BlinkErrorCode.timeout =>
          'We could not reach the verification service. Check your connection and '
              'try again.',
        BlinkErrorCode.sessionExpired ||
        BlinkErrorCode.sessionSpent ||
        BlinkErrorCode.sessionInvalid =>
          'That attempt has expired. Tap Start Verification to begin a new one.',
        BlinkErrorCode.quotaExceeded =>
          'Verification is unavailable at the moment. Please try again later.',
        _ => 'The verification could not be completed. You can try again.',
      };

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: Image.asset(
                'assets/images/second.png',
              ).image,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(),
            child: Padding(
              padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: double.infinity,
                    height: 551.21,
                    decoration: BoxDecoration(),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 30.0),
                          child: Container(
                            width: 294.0,
                            height: 256.87,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: Image.asset(
                                  'assets/images/identity_card.png',
                                ).image,
                              ),
                            ),
                          ),
                        ),
                        Text(
                          'Verify Your Identity',
                          textAlign: TextAlign.center,
                          style: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .override(
                                font: GoogleFonts.inter(
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                                color: FlutterFlowTheme.of(context).primaryText,
                                fontSize: 24.0,
                                letterSpacing: 0.0,
                                fontWeight: FontWeight.w500,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 9.0, 0.0, 0.0),
                          child: Text(
                            'Please prepare your self & your Iqama or ID for a quick scanning & verifying',
                            textAlign: TextAlign.center,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color: Color(0xF2FFFFFF),
                                  fontSize: 13.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                  lineHeight: 1.2,
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 35.0),
                    child: Container(
                      decoration: BoxDecoration(),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                15.0, 0.0, 15.0, 0.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                await _startVerification();
                              },
                              child: Container(
                                width: double.infinity,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  borderRadius: BorderRadius.circular(106.67),
                                ),
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Text(
                                  'Start Verification',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        fontSize: 18.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w600,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: MediaQuery.sizeOf(context).width * 0.35,
                                height: 1.0,
                                decoration: BoxDecoration(
                                  color: Color(0x3AFFFFFF),
                                  borderRadius: BorderRadius.only(),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    5.0, 0.0, 5.0, 0.0),
                                child: Text(
                                  'Or ',
                                  style: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .override(
                                        font: GoogleFonts.inter(
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        fontSize: 13.0,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.sizeOf(context).width * 0.35,
                                height: 1.0,
                                decoration: BoxDecoration(
                                  color: Color(0x3AFFFFFF),
                                  borderRadius: BorderRadius.only(),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                15.0, 0.0, 15.0, 0.0),
                            child: InkWell(
                              splashColor: Colors.transparent,
                              focusColor: Colors.transparent,
                              hoverColor: Colors.transparent,
                              highlightColor: Colors.transparent,
                              onTap: () async {
                                context
                                    .pushNamed(BottomBarPagesWidget.routeName);
                              },
                              child: Container(
                                width: double.infinity,
                                height: 50.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).tertiary,
                                  borderRadius: BorderRadius.circular(106.67),
                                ),
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Link my SAIB account',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.w500,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .primaryText,
                                            fontSize: 18.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(0.0),
                                      child: Image.asset(
                                        'assets/images/button_company_icon.png',
                                        width: 16.0,
                                        height: 29.0,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ].divide(SizedBox(width: 10.0)),
                                ),
                              ),
                            ),
                          ),
                        ].divide(SizedBox(height: 10.0)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
