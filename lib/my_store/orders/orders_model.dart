import '/components/transaction_shimmer_widget.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'orders_widget.dart' show OrdersWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OrdersModel extends FlutterFlowModel<OrdersWidget> {
  ///  Local state fields for this page.

  dynamic orders;

  bool loaded = false;

  int openOrder = -1;

  ///  State fields for stateful widgets in this page.

  // Model for TransactionShimmer component.
  late TransactionShimmerModel transactionShimmerModel1;
  // Model for TransactionShimmer component.
  late TransactionShimmerModel transactionShimmerModel2;
  // Model for TransactionShimmer component.
  late TransactionShimmerModel transactionShimmerModel3;

  @override
  void initState(BuildContext context) {
    transactionShimmerModel1 =
        createModel(context, () => TransactionShimmerModel());
    transactionShimmerModel2 =
        createModel(context, () => TransactionShimmerModel());
    transactionShimmerModel3 =
        createModel(context, () => TransactionShimmerModel());
  }

  @override
  void dispose() {
    transactionShimmerModel1.dispose();
    transactionShimmerModel2.dispose();
    transactionShimmerModel3.dispose();
  }

  /// Action blocks.
  Future loadOrders(BuildContext context) async {
    dynamic? loadedOrders;

    loadedOrders = await actions.haatLoadOrders();
    orders = loadedOrders;
    loaded = true;
    openOrder = -1;
    updatePage(() {});
  }
}
