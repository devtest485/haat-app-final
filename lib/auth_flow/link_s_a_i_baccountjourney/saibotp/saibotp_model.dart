import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'saibotp_widget.dart' show SaibotpWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SaibotpModel extends FlutterFlowModel<SaibotpWidget> {
  ///  Local state fields for this page.

  /// What has been typed into the code boxes so far.
  String otpCode = '';

  bool otpCompleted = false;

  /// Why the last try failed, in words. Empty otherwise.
  String otpError = '';

  /// True while the code is being checked, so Continue cannot be pressed twice.
  bool verifying = false;

  /// True once the thirty seconds have run out and a new code may be asked for.
  bool resendReady = false;

  ///  State fields for stateful widgets in this page.

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

  // Stores action output result for [Custom Action - haatSaibVerify] action in Container widget.
  String? verified;
  // Stores action output result for [Custom Action - haatSaibResend] action in Text widget.
  String? resent;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    timerController.dispose();
  }
}
