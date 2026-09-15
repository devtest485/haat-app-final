import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'pass_code_login_widget.dart' show PassCodeLoginWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PassCodeLoginModel extends FlutterFlowModel<PassCodeLoginWidget> {
  ///  Local state fields for this page.

  String? pinCode = '';

  /// True while the passcode is being checked, so further digits do nothing.
  bool isSubmitting = false;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
