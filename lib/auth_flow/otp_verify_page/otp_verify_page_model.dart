import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_timer.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'otp_verify_page_widget.dart' show OtpVerifyPageWidget;
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OtpVerifyPageModel extends FlutterFlowModel<OtpVerifyPageWidget> {
  ///  Local state fields for this page.

  bool otpCompleted = false;

  /// The digits entered so far. The boxes hold their own text; this is the one place
  /// the assembled code is kept, because it is what gets sent.
  String otpCode = '';

  /// True while a verify or resend is in flight.
  bool isSubmitting = false;

  /// True once the countdown has finished and another code may be asked for.
  ///
  /// Driven by the timer's own `onEnded` rather than by reading the milliseconds left:
  /// the display reaches 00:00 while the counter still holds a few hundred of them, so
  /// a `> 0` test leaves the screen showing "Resend code in 00:00" for ever.
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

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    timerController.dispose();
  }
}
