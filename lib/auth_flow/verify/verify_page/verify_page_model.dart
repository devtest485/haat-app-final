import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'verify_page_widget.dart' show VerifyPageWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class VerifyPageModel extends FlutterFlowModel<VerifyPageWidget> {
  /// True from the moment Start Verification is tapped until the verdict is in.
  bool isVerifying = false;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
