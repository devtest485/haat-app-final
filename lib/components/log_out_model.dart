import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'log_out_widget.dart' show LogOutWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LogOutModel extends FlutterFlowModel<LogOutWidget> {
  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - newUuid] action in Container widget.
  String? logoutKey;
  // Stores action output result for [Backend Call - API (Logout)] action in Container widget.
  ApiCallResponse? logoutResult;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
