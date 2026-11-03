import '/components/product_card/product_card_widget.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
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

  String? loadError;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - haatLoadProducts] action in Products widget.
  List<dynamic>? loadedProducts;
  // Stores action output result for [Custom Action - haatLoadProducts] action in ProductCard widget.
  List<dynamic>? productsAfterEdit;
  // Stores action output result for [Custom Action - haatLoadProducts] action in Container widget.
  List<dynamic>? productsAfterAdd;
  // Stores action output result for [Custom Action - haatLoadProducts] action in Container widget.
  List<dynamic>? productsAfterAdds;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
