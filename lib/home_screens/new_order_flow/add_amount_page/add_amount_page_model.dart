import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home_screens/new_order_flow/select_pay_out/select_pay_out_widget.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'add_amount_page_widget.dart' show AddAmountPageWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddAmountPageModel extends FlutterFlowModel<AddAmountPageWidget> {
  ///  Local state fields for this page.

  bool switchTab = false;

  bool enterText = false;

  String? amount = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
