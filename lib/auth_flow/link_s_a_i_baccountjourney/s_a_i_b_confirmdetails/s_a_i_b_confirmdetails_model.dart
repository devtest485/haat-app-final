import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/actions/index.dart' as actions;
import 'dart:ui';
import '/index.dart';
import 's_a_i_b_confirmdetails_widget.dart' show SAIBConfirmdetailsWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SAIBConfirmdetailsModel
    extends FlutterFlowModel<SAIBConfirmdetailsWidget> {
  ///  Local state fields for this page.

  /// True once the account is linked, which puts the Account linked screen over this one.
  bool linked = false;

  /// True while the account is being linked, so Continue cannot be pressed twice.
  bool confirming = false;

  /// Why linking failed, in words. Empty otherwise.
  String confirmError = '';

  // Stores action output result for [Custom Action - haatSaibConfirm] action in Container widget.
  String? confirmed;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
