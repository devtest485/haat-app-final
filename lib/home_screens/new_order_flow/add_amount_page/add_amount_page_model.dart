import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home_screens/new_order_flow/add_amount_view/add_amount_view_widget.dart';
import 'add_amount_page_widget.dart' show AddAmountPageWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddAmountPageModel extends FlutterFlowModel<AddAmountPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for AddAmountView component.
  late AddAmountViewModel addAmountViewModel;

  @override
  void initState(BuildContext context) {
    addAmountViewModel = createModel(context, () => AddAmountViewModel());
  }

  @override
  void dispose() {
    addAmountViewModel.dispose();
  }
}
