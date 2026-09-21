import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'transactions_detials_widget.dart' show TransactionsDetialsWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TransactionsDetialsModel
    extends FlutterFlowModel<TransactionsDetialsWidget> {
  ///  Local state fields for this page.

  bool transactions = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - haatHasTransactions] action in TransactionsDetials widget.
  bool? traded;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
