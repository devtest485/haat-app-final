import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'otp_verify_page_widget.dart' show OtpVerifyPageWidget;
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OtpVerifyPageModel extends FlutterFlowModel<OtpVerifyPageWidget> {
  ///  Local state fields for this page.

  bool otpCompleted = false;

  String? otpCode;

  bool isSubmitting = false;

  bool resendReady = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - getDeviceLabel] action in OtpVerify widget.
  String? deviceLabel;
  // Stores action output result for [Custom Action - getPlatformName] action in OtpVerify widget.
  String? platformName;
  // Stores action output result for [Backend Call - API (VerifyOtp)] action in OtpVerify widget.
  ApiCallResponse? verifyResult;
  // Stores action output result for [Backend Call - API (CredentialStatus)] action in OtpVerify widget.
  ApiCallResponse? credResult;
  // State field(s) for Timer widget.
  final timerInitialTimeMs = 30000;
  int timerMilliseconds = 30000;
  String timerValue = StopWatchTimer.getDisplayTime(
    30000,
    hours: false,
    milliSecond: false,
  );
  FlutterFlowTimerController timerController =
      FlutterFlowTimerController(StopWatchTimer(mode: StopWatchMode.countDown));

  // Stores action output result for [Custom Action - haatResendOtp] action in Text widget.
  String? resent;
  // Stores action output result for [Custom Action - haatDevOtpCode] action in Text widget.
  String? resentCode;
  // Stores action output result for [Custom Action - haatVerifyOtp] action in Container widget.
  String? verified;
  // Stores action output result for [Custom Action - haatStartupRoute] action in Container widget.
  String? startupRoute;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    timerController.dispose();
  }
}
