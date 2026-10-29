import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'remove_branch_widget.dart' show RemoveBranchWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RemoveBranchModel extends FlutterFlowModel<RemoveBranchWidget> {
  ///  Local state fields for this component.

  bool removing = false;

  String? error;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - haatAccessToken] action in Container widget.
  String? token;
  // Stores action output result for [Backend Call - API (CloseBranch)] action in Container widget.
  ApiCallResponse? closeResult;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
