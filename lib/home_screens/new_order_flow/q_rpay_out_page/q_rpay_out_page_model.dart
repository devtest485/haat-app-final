import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'q_rpay_out_page_widget.dart' show QRpayOutPageWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class QRpayOutPageModel extends FlutterFlowModel<QRpayOutPageWidget> {
  ///  Local state fields for this page.

  dynamic request;

  String problem = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  /// Action blocks.
  Future makeRequest(BuildContext context) async {
    dynamic? created;
    dynamic? waited;

    problem = '';
    request = null;
    updatePage(() {});
    created = await actions.haatCreatePayRequest(
      widget!.amount,
      false,
    );
    if (functions.outcomeText(created, 'error', '') != null &&
        functions.outcomeText(created, 'error', '') != '') {
      problem = functions.outcomeText(created, 'error', '');
      updatePage(() {});
    } else {
      request = created;
      updatePage(() {});
      waited = await actions.haatAwaitPayRequest(
        context,
        request,
      );
      if (functions.outcomeText(waited, 'paymentStatus', '') == 'Success') {
        if (Navigator.of(context).canPop()) {
          context.pop();
        }
        context.pushNamed(
          PaymentStatusWidget.routeName,
          queryParameters: {
            'paymentStatus': serializeParam(
              functions.outcomeText(waited, 'paymentStatus', 'Error'),
              ParamType.String,
            ),
            'outcome': serializeParam(
              waited,
              ParamType.JSON,
            ),
          }.withoutNulls,
        );
      } else if (functions.outcomeText(waited, 'problem', '') != null &&
          functions.outcomeText(waited, 'problem', '') != '') {
        problem = functions.outcomeText(waited, 'problem', '');
        request = null;
        updatePage(() {});
      }
    }
  }
}
