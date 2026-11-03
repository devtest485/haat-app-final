import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'pay_request_approval_widget.dart' show PayRequestApprovalWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PayRequestApprovalModel
    extends FlutterFlowModel<PayRequestApprovalWidget> {
  ///  Local state fields for this page.

  dynamic preview;

  bool loading = true;

  bool paying = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - haatApprovePayRequest] action in Container widget.
  dynamic? outcome;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  /// Action blocks.
  Future loadRequest(BuildContext context) async {
    dynamic? found;

    loading = true;
    preview = null;
    updatePage(() {});
    found = await actions.haatPreviewPayRequest(
      widget!.code,
    );
    preview = found;
    loading = false;
    updatePage(() {});
  }
}
