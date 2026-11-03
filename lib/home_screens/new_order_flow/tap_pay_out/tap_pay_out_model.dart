import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'tap_pay_out_widget.dart' show TapPayOutWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TapPayOutModel extends FlutterFlowModel<TapPayOutWidget> {
  ///  Local state fields for this page.

  dynamic request;

  String problem = '';

  String phase = '';

  String waiting = '';

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  /// Action blocks.
  Future startTap(BuildContext context) async {
    dynamic? created;
    dynamic? tapped;
    dynamic? waited;

    problem = '';
    phase = '';
    waiting = '';
    request = null;
    updatePage(() {});
    created = await actions.haatCreateTapPayment(
      widget!.amount,
    );
    if (functions.outcomeText(created, 'error', '') != null &&
        functions.outcomeText(created, 'error', '') != '') {
      problem = functions.outcomeText(created, 'error', '');
      updatePage(() {});
    } else if (functions.outcomeText(created, 'paymentStatus', '') != null &&
        functions.outcomeText(created, 'paymentStatus', '') != '') {
      if (Navigator.of(context).canPop()) {
        context.pop();
      }
      context.pushNamed(
        PaymentStatusWidget.routeName,
        queryParameters: {
          'paymentStatus': serializeParam(
            functions.outcomeText(created, 'paymentStatus', 'Error'),
            ParamType.String,
          ),
          'outcome': serializeParam(
            created,
            ParamType.JSON,
          ),
        }.withoutNulls,
      );
    } else {
      request = created;
      updatePage(() {});
      tapped = await actions.haatTapToPay(
        context,
        request,
      );
      if (functions.outcomeText(tapped, 'paymentStatus', '') != null &&
          functions.outcomeText(tapped, 'paymentStatus', '') != '') {
        if (Navigator.of(context).canPop()) {
          context.pop();
        }
        context.pushNamed(
          PaymentStatusWidget.routeName,
          queryParameters: {
            'paymentStatus': serializeParam(
              functions.outcomeText(tapped, 'paymentStatus', 'Error'),
              ParamType.String,
            ),
            'outcome': serializeParam(
              tapped,
              ParamType.JSON,
            ),
          }.withoutNulls,
        );
      } else if (functions.outcomeText(tapped, 'confirm', '') == 'true') {
        phase = 'confirm';
        waiting = functions.outcomeText(tapped, 'waiting', '');
        updatePage(() {});
        waited = await actions.haatAwaitTapApproval(
          context,
          request,
          tapped,
        );
        if (functions.outcomeText(waited, 'paymentStatus', '') != null &&
            functions.outcomeText(waited, 'paymentStatus', '') != '') {
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
          phase = '';
          waiting = '';
          updatePage(() {});
        }
      } else if (functions.outcomeText(tapped, 'problem', '') != null &&
          functions.outcomeText(tapped, 'problem', '') != '') {
        problem = functions.outcomeText(tapped, 'problem', '');
        updatePage(() {});
      }
    }
  }
}
