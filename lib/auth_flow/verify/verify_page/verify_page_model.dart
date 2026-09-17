import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'verify_page_widget.dart' show VerifyPageWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class VerifyPageModel extends FlutterFlowModel<VerifyPageWidget> {
  ///  Local state fields for this page.

  bool isVerifying = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - haatRunKyc] action in Container widget.
  String? kyc;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
