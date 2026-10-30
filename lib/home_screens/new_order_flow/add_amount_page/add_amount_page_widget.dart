import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home_screens/new_order_flow/add_amount_view/add_amount_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'add_amount_page_model.dart';
export 'add_amount_page_model.dart';

class AddAmountPageWidget extends StatefulWidget {
  const AddAmountPageWidget({super.key});

  static String routeName = 'AddAmountPage';
  static String routePath = '/addAmountPage';

  @override
  State<AddAmountPageWidget> createState() => _AddAmountPageWidgetState();
}

class _AddAmountPageWidgetState extends State<AddAmountPageWidget> {
  late AddAmountPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => AddAmountPageModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: wrapWithModel(
          model: _model.addAmountViewModel,
          updateCallback: () => safeSetState(() {}),
          child: AddAmountViewWidget(),
        ),
      ),
    );
  }
}
