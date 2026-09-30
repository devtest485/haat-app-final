import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'login_screen_widget.dart' show LoginScreenWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginScreenModel extends FlutterFlowModel<LoginScreenWidget> {
  /// Whether this handset holds a device key, so the fingerprint option is shown.
  bool hasBiometricKey = false;

  /// Whether this handset was bound for passcode sign-in, so that option is shown.
  bool hasPasscodeSignIn = false;

  /// Set once the fingerprint is accepted, so the mark turns into a tick.
  bool biometricDone = false;

  /// True while the prompt is up, so a second tap cannot spend a second challenge.
  bool isSigningIn = false;

  // Stores action output result for [Custom Action - haatSignInWithBiometrics].
  String? biometricSignIn;
  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
