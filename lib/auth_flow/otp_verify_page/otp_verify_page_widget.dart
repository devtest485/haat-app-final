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
import 'package:flutter/foundation.dart' show kDebugMode;
import '/backend/api/api_result.dart';
import '/backend/api/auth_api.dart';
import '/backend/auth/auth_session.dart';
import '/backend/ui/api_feedback.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // The screen says "Resend code in 00:30", so something has to be counting. The
      // designer's timer was never started, which left the label frozen and resending
      // unreachable.
      _model.timerController.onStartTimer();
      safeSetState(() {});
    });
  }

  /// The one-time code, when a development backend handed it back.
  ///
  /// Null in a release build whatever the server sends, and null against production
  /// whatever the build — so this is two independent conditions, not one.
  ///
  /// It saves typing during development and bypasses nothing: the digits still go to
  /// `POST /auth/verify-otp` and are still verified there. See
  /// `docs/BEFORE-GOING-LIVE.md`.
  String? get _devCode => kDebugMode ? AuthSession.instance.devOtpCode : null;

  /// Verifies the code and moves on to setting a password.
  ///
  /// Shared by the automatic submit when the sixth digit lands and by the Continue
  /// button, so both behave identically.
  Future<void> _submitCode() async {
    if (_model.isSubmitting || _model.otpCode.length < 6) return;

    final feedback = ApiFeedback.of(context);
    safeSetState(() => _model.isSubmitting = true);

    final result = await AuthSession.instance.verifyOtp(
      code: _model.otpCode,
      mobile: widget.phoneNum,
    );

    if (!mounted) return;
    safeSetState(() => _model.isSubmitting = false);

    if (!result.isSuccess) {
      feedback.show(result);
      return;
    }

    context.pushNamed(CreatePasswordPageWidget.routeName);
  }

  /// Asks for another code and restarts the countdown.
  Future<void> _resend() async {
    if (_model.isResending) return;

    final feedback = ApiFeedback.of(context);
    safeSetState(() => _model.isResending = true);

    final result =
        await AuthSession.instance.resendOtp(mobile: widget.phoneNum);

    if (!mounted) return;
    safeSetState(() {
      _model.isResending = false;
      if (result.isSuccess) {
        _model.canResend = false;
        _model.timerController.onResetTimer();
        _model.timerController.onStartTimer();
      }
    });

    // Shown on success too: "we have sent another code" is the confirmation the user
    // is waiting for, and silence looks like the tap did nothing.
    feedback.show(result, onlyOnFailure: false);

    if (result case ApiSuccess<RegistrationStarted>(:final value)) {
      _showDevCode(feedback, value.devOtpCode);
    }
  }

  /// In a debug build against a non-production backend, puts the code on screen.
  ///
  /// The backend returns it precisely so the flow can be walked through without an SMS
  /// gateway, which there is not one of yet. Guarded by [kDebugMode] so a release build
  /// cannot show it even if a server were misconfigured to send it.
  void _showDevCode(ApiFeedback feedback, String? code) {
    if (!kDebugMode || code == null || code.isEmpty) return;

    feedback.notice('Development code: $code');
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
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
                                  Icon(
                                    Icons.arrow_back,
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    size: 24.0,
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
                                                initialValue: _devCode,
                                                onChanged: (otpValue) async {
                                                  _model.otpCode = otpValue;
                                                  _model.otpCompleted =
                                                      otpValue.length == 6;
                                                  safeSetState(() {});
                                                },
                                                onCompleted:
                                                    (isComplete) async {
                                                  if (isComplete == true) {
                                                    await _submitCode();
                                                  }
                                                },
                                              ),
                                            ),
                                            // Says out loud that the code was
                                            // filled in for you. A shortcut nobody
                                            // can see is one somebody will mistake
                                            // for the real thing working.
                                            if (_devCode != null)
                                              Padding(
                                                padding:
                                                    const EdgeInsetsDirectional
                                                        .fromSTEB(0, 4, 0, 0),
                                                child: Text(
                                                  'Development build: code filled in automatically.',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodySmall
                                                      .override(
                                                        font:
                                                            GoogleFonts.inter(),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .warning,
                                                        fontSize: 11.0,
                                                        letterSpacing: 0.0,
                                                      ),
                                                ),
                                              ),
                                            if (_model.canResend)
                                              InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async =>
                                                    await _resend(),
                                                child: Text(
                                                  _model.isResending
                                                      ? 'Sending…'
                                                      : 'Resend code',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        decoration:
                                                            TextDecoration
                                                                .underline,
                                                      ),
                                                ),
                                              ),
                                            if (!_model.canResend)
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
                                                    onChanged: (value,
                                                        displayTime,
                                                        shouldUpdate) {
                                                      _model.timerMilliseconds =
                                                          value;
                                                      _model.timerValue =
                                                          displayTime;
                                                      // Counting down, so zero is the
                                                      // end. That is when the backend
                                                      // will accept another request.
                                                      if (value <= 0 &&
                                                          !_model.canResend) {
                                                        _model.canResend = true;
                                                        safeSetState(() {});
                                                        return;
                                                      }
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
                          onTap: () async {
                            await _submitCode();
                          },
                          child: Container(
                            width: double.infinity,
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: _model.otpCompleted == true
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
                                    color: _model.otpCompleted == true
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
