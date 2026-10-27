import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

import 'dart:ui';

import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/components/empty_state/empty_state_widget.dart';
import '/index.dart';
import 'products_widget.dart' show ProductsWidget;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ProductsModel extends FlutterFlowModel<ProductsWidget> {
  ///  Local state fields for this page.

  List<dynamic> products = [];
  void addToProducts(dynamic item) => products.add(item);
  void removeFromProducts(dynamic item) => products.remove(item);
  void removeAtIndexFromProducts(int index) => products.removeAt(index);
  void insertAtIndexInProducts(int index, dynamic item) =>
      products.insert(index, item);
  void updateProductsAtIndex(int index, Function(dynamic) updateFn) =>
      products[index] = updateFn(products[index]);

  bool productsLoaded = false;

  String loadError = '';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - haatAccessToken] action in Products widget.
  String? token;
  // Stores action output result for [Backend Call - API (Products)] action in Products widget.
  ApiCallResponse? productsResult;
  // Model for EmptyState component.
  late EmptyStateModel emptyStateModel;

  @override
  void initState(BuildContext context) {
    emptyStateModel = createModel(context, () => EmptyStateModel());
  }

  @override
  void dispose() {
    emptyStateModel.dispose();
  }
}
