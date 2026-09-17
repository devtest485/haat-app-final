import '/backend/auth/auth_session.dart';
import '/backend/ui/api_feedback.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'otp_verify_page_model.dart';
export 'otp_verify_page_model.dart';

class OtpVerifyPageWidget extends StatefulWidget {
  const OtpVerifyPageWidget({
    super.key,
    required this.phoneNum,
  });

  final String? phoneNum;

  static String routeName = 'OtpVerifyPage';
  static String routePath = '/otpVerifyPage';

  @override
  State<OtpVerifyPageWidget> createState() => _OtpVerifyPageWidgetState();
}

class _OtpVerifyPageWidgetState extends State<OtpVerifyPageWidget> {
  late OtpVerifyPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OtpVerifyPageModel());

    // The screen promises "Resend code in 00:30", so the countdown has to be running.
    // Nothing else starts it, and a frozen 00:30 never gets round to offering a resend.
    _model.timerController.onStartTimer();

    WidgetsBinding.instance.addPostFrameCallback((_) => safeSetState(() {}));
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  /// How many digits the code has.
  ///
  /// Stated once and handed to the boxes as well as used to decide when the code is
  /// complete, so the two can never disagree about what "filled in" means.
  static const int _otpLength = 6;

  /// Whether Continue is live: a full code in, and nothing already in flight.
  bool get _canSubmit => _model.otpCompleted && !_model.isSubmitting;

  // ── Actions ───────────────────────────────────────────────────────────────────

  /// Verifies the code and adopts the session it returns.
  ///
  /// The number is not passed: the session remembered it when registration started,
  /// which still holds after the app has been backgrounded waiting for an SMS.
  Future<void> _verify() async {
    if (!_canSubmit) return;

    final feedback = ApiFeedback.of(context);

    safeSetState(() => _model.isSubmitting = true);

    final result = await AuthSession.instance.verifyOtp(code: _model.otpCode);

    if (!mounted) return;
    safeSetState(() => _model.isSubmitting = false);

    if (!result.isSuccess) {
      // A wrong or spent code leaves the boxes as they are — retyping six digits to
      // correct one is its own small punishment — and the backend's own sentence
      // says which of the two it was.
      feedback.show(result);
      return;
    }

    final next = _nextRoute();

    // A finished account has just signed in rather than signed up, so the sign-up
    // screens behind this one are not somewhere to go back to.
    if (next == BottomBarPagesWidget.routeName) {
      context.goNamed(next);
    } else {
      context.pushNamed(next);
    }
  }

  /// Where the account goes now that it has proved the number.
  ///
  /// An already-registered number gets a code and a session exactly like a new one —
  /// the backend will not confirm to a stranger that an account exists — so this screen
  /// cannot assume a fresh sign-up. What the account already holds decides where it
  /// resumes. Sending everyone to "create a password" is what asked an account that
  /// already had one for its current password.
  String _nextRoute() {
    final credentials = AuthSession.instance.credentials;

    // Only a first password is set from here. Replacing one needs the current password
    // as well, which this flow never collects — and an account in that state signs in
    // by handle rather than by code, so it does not reach this screen.
    if (credentials == null || !credentials.hasPassword) {
      return CreatePasswordPageWidget.routeName;
    }

    if (!credentials.hasPasscode) return SecurePageWidget.routeName;
    if (credentials.username == null) return UsernamePageWidget.routeName;

    return BottomBarPagesWidget.routeName;
  }

  /// Asks for a new code, which invalidates the one already sent.
  Future<void> _resend() async {
    if (_model.isSubmitting) return;

    final feedback = ApiFeedback.of(context);

    safeSetState(() => _model.isSubmitting = true);

    final result = await AuthSession.instance.resendOtp();

    if (!mounted) return;
    safeSetState(() => _model.isSubmitting = false);

    // Shown either way here: "we have sent another one" is the whole point of the tap,
    // so silence on success would read as nothing having happened.
    feedback.show(result, onlyOnFailure: false);

    if (result.isSuccess) {
      safeSetState(() => _model.resendReady = false);
      _model.timerController.onResetTimer();
      _model.timerController.onStartTimer();
    }
  }

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
            color: Colors.black,
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: double.infinity,
                    height: 162.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: Image.asset(
                          'assets/images/GreenPageBg.png',
                        ).image,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 67.0, 0.0, 0.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.17,
                                      height: 3.0,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        borderRadius:
                                            BorderRadius.circular(2.0),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.17,
                                      height: 3.0,
                                      decoration: BoxDecoration(
                                        color: Color(0x4DFFFFFF),
                                        borderRadius:
                                            BorderRadius.circular(2.0),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.17,
                                      height: 3.0,
                                      decoration: BoxDecoration(
                                        color: Color(0x4DFFFFFF),
                                        borderRadius:
                                            BorderRadius.circular(2.0),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.17,
                                      height: 3.0,
                                      decoration: BoxDecoration(
                                        color: Color(0x4CFFFFFF),
                                        borderRadius:
                                            BorderRadius.circular(2.0),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.17,
                                      height: 3.0,
                                      decoration: BoxDecoration(
                                        color: Color(0x4DFFFFFF),
                                        borderRadius:
                                            BorderRadius.circular(2.0),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 19.0, 0.0, 0.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      context.safePop();
                                    },
                                    child: Icon(
                                      Icons.arrow_back,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryText,
                                      size: 24.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 19.0, 0.0, 0.0),
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 10.0, 0.0, 0.0),
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '6-digit code',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    fontSize: 30.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                            ),
                                            RichText(
                                              textScaler: MediaQuery.of(context)
                                                  .textScaler,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text:
                                                        'Enter the code sent to ',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 15.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                          lineHeight: 1.4,
                                                        ),
                                                  ),
                                                  TextSpan(
                                                    text: functions
                                                        .maskPhoneNumber(
                                                            widget!.phoneNum!),
                                                    style: TextStyle(),
                                                  )
                                                ],
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      fontSize: 15.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontWeight,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                      lineHeight: 1.4,
                                                    ),
                                              ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              height: 62.0,
                                              child: custom_widgets.OtpVerify(
                                                width: double.infinity,
                                                height: 62.0,
                                                autoFocus: true,
                                                otpLength: _otpLength,
                                                onChanged: (otpValue) async {
                                                  safeSetState(() {
                                                    _model.otpCode = otpValue;
                                                    _model.otpCompleted =
                                                        otpValue.length ==
                                                            _otpLength;
                                                  });
                                                },
                                                onCompleted:
                                                    (isComplete) async {
                                                  // Filling the last box submits, so
                                                  // the usual case needs no button.
                                                  if (isComplete == true) {
                                                    await _verify();
                                                  }
                                                },
                                              ),
                                            ),
                                            // Shown whenever the server sends one, and
                                            // the server is what decides. A backend
                                            // with no SMS provider returns the code in
                                            // `devOtpCode` only while `EXPOSE_OTP_CODE`
                                            // is set; a real one leaves the field null
                                            // and nothing renders.
                                            //
                                            // This used to be gated on `kDebugMode` as
                                            // well, which was the wrong control: it hid
                                            // the code from the release builds handed
                                            // to testers, whose backend is the one
                                            // deliberately handing it out, while adding
                                            // no protection at all — the code is in the
                                            // response body either way, and the only
                                            // thing that keeps it out of production is
                                            // the server not sending it.
                                            if (AuthSession
                                                    .instance.devOtpCode !=
                                                null)
                                              SelectableText(
                                                'Development code: ${AuthSession.instance.devOtpCode}',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .primaryText,
                                                      fontSize: 13.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                              ),
                                            if (!_model.resendReady)
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    'Resend code in',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryText,
                                                          fontSize: 13.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                          lineHeight: 1.4,
                                                        ),
                                                  ),
                                                  FlutterFlowTimer(
                                                    initialTime: _model
                                                        .timerInitialTimeMs,
                                                    getDisplayTime: (value) =>
                                                        StopWatchTimer
                                                            .getDisplayTime(
                                                      value,
                                                      hours: false,
                                                      milliSecond: false,
                                                    ),
                                                    controller:
                                                        _model.timerController,
                                                    updateStateInterval:
                                                        Duration(
                                                            milliseconds: 1000),
                                                    onEnded: () => safeSetState(
                                                        () => _model
                                                            .resendReady = true),
                                                    onChanged: (value,
                                                        displayTime,
                                                        shouldUpdate) {
                                                      _model.timerMilliseconds =
                                                          value;
                                                      _model.timerValue =
                                                          displayTime;
                                                      if (shouldUpdate)
                                                        safeSetState(() {});
                                                    },
                                                    textAlign: TextAlign.start,
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .headlineSmall
                                                        .override(
                                                          font: GoogleFonts
                                                              .interTight(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .headlineSmall
                                                                    .fontStyle,
                                                          ),
                                                          fontSize: 12.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .headlineSmall
                                                                  .fontStyle,
                                                        ),
                                                  ),
                                                ].divide(SizedBox(width: 5.0)),
                                              )
                                            else
                                              InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: _resend,
                                                child: Text(
                                                  'Resend code',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontSize: 13.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                        lineHeight: 1.4,
                                                      ),
                                                ),
                                              ),
                                          ].divide(SizedBox(height: 7.0)),
                                        ),
                                      ),
                                    ),
                                  ].divide(SizedBox(height: 24.0)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            15.0, 0.0, 15.0, 35.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: _verify,
                          child: Container(
                            width: double.infinity,
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: _canSubmit
                                  ? FlutterFlowTheme.of(context).primaryText
                                  : FlutterFlowTheme.of(context).secondary,
                              borderRadius: BorderRadius.circular(106.67),
                            ),
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Text(
                              'Continue',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: _canSubmit
                                        ? FlutterFlowTheme.of(context)
                                            .primaryBackground
                                        : FlutterFlowTheme.of(context).primary,
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
