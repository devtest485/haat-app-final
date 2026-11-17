import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/my_store/store/store_widget.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'brand_store_widget.dart' show BrandStoreWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BrandStoreModel extends FlutterFlowModel<BrandStoreWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for Store component.
  late StoreModel storeModel;

  @override
  void initState(BuildContext context) {
    storeModel = createModel(context, () => StoreModel());
  }

  @override
  void dispose() {
    storeModel.dispose();
  }
}
