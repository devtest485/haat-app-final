import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'transaction_filter_sheet_widget.dart' show TransactionFilterSheetWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TransactionFilterSheetModel
    extends FlutterFlowModel<TransactionFilterSheetWidget> {
  ///  State fields for stateful widgets in this component.

  // State field(s) for directionChips widget.
  FormFieldController<List<String>>? directionChipsValueController;
  String? get directionChipsValue =>
      directionChipsValueController?.value?.firstOrNull;
  set directionChipsValue(String? val) =>
      directionChipsValueController?.value = val != null ? [val] : [];
  // State field(s) for statusChips widget.
  FormFieldController<List<String>>? statusChipsValueController;
  String? get statusChipsValue =>
      statusChipsValueController?.value?.firstOrNull;
  set statusChipsValue(String? val) =>
      statusChipsValueController?.value = val != null ? [val] : [];
  // State field(s) for methodChips widget.
  FormFieldController<List<String>>? methodChipsValueController;
  String? get methodChipsValue =>
      methodChipsValueController?.value?.firstOrNull;
  set methodChipsValue(String? val) =>
      methodChipsValueController?.value = val != null ? [val] : [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
