import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'tap_pay_out_widget.dart' show TapPayOutWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
      await showTapResult(
        context,
        outcome: created,
      );
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
        await showTapResult(
          context,
          outcome: tapped,
        );
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
          await showTapResult(
            context,
            outcome: waited,
          );
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
        } else if (functions.outcomeText(waited, 'declined', '') != null &&
            functions.outcomeText(waited, 'declined', '') != '') {
          phase = 'rejected';
          waiting = 'The customer declined the payment';
          updatePage(() {});
          await Future.delayed(
            Duration(
              milliseconds: 1500,
            ),
          );
          context.pop();
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

  Future showTapResult(
    BuildContext context, {
    dynamic outcome,
  }) async {
    if (functions.outcomeText(outcome, 'paymentStatus', '') == 'Success') {
      phase = 'paid';
      waiting = 'Payment received';
      updatePage(() {});
      await Future.delayed(
        Duration(
          milliseconds: 1500,
        ),
      );
    } else if (functions.outcomeText(outcome, 'paymentStatus', '') == 'Error') {
      phase = 'rejected';
      waiting = 'The payment didn’t go through';
      updatePage(() {});
      await Future.delayed(
        Duration(
          milliseconds: 1200,
        ),
      );
    }
  }
}
