import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'login_screen_widget.dart' show LoginScreenWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginScreenModel extends FlutterFlowModel<LoginScreenWidget> {
  /// Whether this handset holds a device key, so the biometric option is worth showing.
  bool hasBiometricKey = false;

  /// True while the prompt is up or the signature is being checked, so a second tap
  /// cannot start a second attempt against a challenge the first one already spent.
  bool isSigningIn = false;

  /// The automatic prompt fires once per visit. Without this, coming back from the
  /// passcode screen would raise the sheet again in front of somebody who has just
  /// deliberately chosen not to use it.
  bool hasOfferedBiometrics = false;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
