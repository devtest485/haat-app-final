import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

import 'dart:ui';

import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'delete_product_sheet_widget.dart' show DeleteProductSheetWidget;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class DeleteProductSheetModel
    extends FlutterFlowModel<DeleteProductSheetWidget> {
  ///  Local state fields for this component.

  bool deleting = false;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - haatAccessToken] action in Container widget.
  String? token;
  // Stores action output result for [Backend Call - API (DeleteProduct)] action in Container widget.
  ApiCallResponse? deleteResult;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
