import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'creating_profile_widget.dart' show CreatingProfileWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreatingProfileModel extends FlutterFlowModel<CreatingProfileWidget> {
  ///  Local state fields for this page.

  int attempt = 0;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - haatAccessToken] action in CreatingProfile widget.
  String? token;
  // Stores action output result for [Backend Call - API (CreateStaff)] action in CreatingProfile widget.
  ApiCallResponse? createResult;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
