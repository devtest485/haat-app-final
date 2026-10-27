import '/backend/api_requests/api_calls.dart';
import '/components/transactions/transactions_widget.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/instant_timer.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'transactions_detials_widget.dart' show TransactionsDetialsWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TransactionsDetialsModel
    extends FlutterFlowModel<TransactionsDetialsWidget> {
  ///  Local state fields for this page.

  bool transactions = false;

  List<dynamic> transactionList = [];
  void addToTransactionList(dynamic item) => transactionList.add(item);
  void removeFromTransactionList(dynamic item) => transactionList.remove(item);
  void removeAtIndexFromTransactionList(int index) =>
      transactionList.removeAt(index);
  void insertAtIndexInTransactionList(int index, dynamic item) =>
      transactionList.insert(index, item);
  void updateTransactionListAtIndex(int index, Function(dynamic) updateFn) =>
      transactionList[index] = updateFn(transactionList[index]);

  int filterIndex = 0;

  String searchQuery = '';

  bool transactionsLoaded = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - haatHasTransactions] action in TransactionsDetials widget.
  bool? traded;
  // Stores action output result for [Custom Action - haatAccessToken] action in TransactionsDetials widget.
  String? token;
  InstantTimer? instantTimer;
  // Stores action output result for [Backend Call - API (RecentTransactions)] action in TransactionsDetials widget.
  ApiCallResponse? transactionsResult;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    instantTimer?.cancel();
  }
}
