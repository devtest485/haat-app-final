import '/components/transaction_shimmer_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import 'orders_widget.dart' show OrdersWidget;
import 'package:flutter/material.dart';

class OrdersModel extends FlutterFlowModel<OrdersWidget> {
  ///  Local state fields for this page.

  /// `ok` and `orders`, from haatLoadOrders.
  dynamic orders;

  bool loaded = false;

  /// The order whose items are showing; -1 for none.
  int openOrder = -1;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - haatLoadOrders] action in Orders widget.
  dynamic loadedOrders;
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
    loadedOrders = await actions.haatLoadOrders();
    orders = loadedOrders;
    loaded = true;
    openOrder = -1;
  }
}
