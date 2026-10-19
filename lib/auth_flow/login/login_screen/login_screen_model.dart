import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'login_screen_widget.dart' show LoginScreenWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginScreenModel extends FlutterFlowModel<LoginScreenWidget> {
  ///  Local state fields for this page.

  bool? hasBiometricKey = false;

  bool? hasPasscodeSignIn = false;

  bool? isSigningIn = false;

  bool? biometricDone = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - haatHasPasscodeSignIn] action in LoginScreen widget.
  bool? passcodeSignIn;
  // Stores action output result for [Custom Action - haatHasBiometricKey] action in LoginScreen widget.
  bool? biometricKey;
  // Stores action output result for [Custom Action - haatSignInWithBiometrics] action in LoginScreen widget.
  String? biometricSignIn;
  // Stores action output result for [Custom Action - haatSignInWithBiometrics] action in BiometricMark widget.
  String? biometricRetry;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
