import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home_screens/add_transfer_funds/method_selection/method_selection_widget.dart';
import 'dart:ui';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'add_fund_widget.dart' show AddFundWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class AddFundModel extends FlutterFlowModel<AddFundWidget> {
  ///  Local state fields for this page.

  bool addFunds = false;

  String? fundAmount;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
