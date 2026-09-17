import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'verify_page_widget.dart' show VerifyPageWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class VerifyPageModel extends FlutterFlowModel<VerifyPageWidget> {
  ///  Local state fields for this page.

  bool isVerifying = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - newUuid] action in Container widget.
  String? sessionKey;
  // Stores action output result for [Backend Call - API (KycProviderSession)] action in Container widget.
  ApiCallResponse? sessionResult;
  // Stores action output result for [Custom Action - runKycCapture] action in Container widget.
  String? captureResult;
  // Stores action output result for [Custom Action - newUuid] action in Container widget.
  String? resultKey;
  // Stores action output result for [Backend Call - API (KycProviderResult)] action in Container widget.
  ApiCallResponse? outcomeResult;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
