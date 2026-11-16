import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/payment_status/payment_error/payment_error_widget.dart';
import '/payment_status/payment_pending/payment_pending_widget.dart';
import '/payment_status/payment_success/payment_success_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'payment_status_model.dart';
export 'payment_status_model.dart';

class PaymentStatusWidget extends StatefulWidget {
  const PaymentStatusWidget({
    super.key,
    required this.paymentStatus,
    this.outcome,
  });

  final String? paymentStatus;
  final dynamic outcome;

  static String routeName = 'PaymentStatus';
  static String routePath = '/paymentStatus';

  @override
  State<PaymentStatusWidget> createState() => _PaymentStatusWidgetState();
}

class _PaymentStatusWidgetState extends State<PaymentStatusWidget> {
  late PaymentStatusModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PaymentStatusModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if ((widget!.paymentStatus == 'Pending') &&
          (functions.outcomeText(widget!.outcome, 'transactionId', '') != '')) {
        _model.decisionResult = await actions.haatAwaitDecision(
          context,
          widget!.outcome!,
        );
        _model.decided = _model.decisionResult;
        safeSetState(() {});
      }
    });
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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(),
          child: Builder(
            builder: (context) {
              if ((functions.outcomeText(_model.decided, 'paymentStatus', '') !=
                          ''
                      ? functions.outcomeText(
                          _model.decided, 'paymentStatus', '')
                      : widget!.paymentStatus) ==
                  'Success') {
                return wrapWithModel(
                  model: _model.paymentSuccessModel,
                  updateCallback: () => safeSetState(() {}),
                  child: PaymentSuccessWidget(
                    outcome: functions.outcomeText(
                                _model.decided, 'paymentStatus', '') !=
                            ''
                        ? _model.decided
                        : widget!.outcome,
                  ),
                );
              } else if ((functions.outcomeText(
                              _model.decided, 'paymentStatus', '') !=
                          ''
                      ? functions.outcomeText(
                          _model.decided, 'paymentStatus', '')
                      : widget!.paymentStatus) ==
                  'Pending') {
                return wrapWithModel(
                  model: _model.paymentPendingModel,
                  updateCallback: () => safeSetState(() {}),
                  child: PaymentPendingWidget(
                    outcome: functions.outcomeText(
                                _model.decided, 'paymentStatus', '') !=
                            ''
                        ? _model.decided
                        : widget!.outcome,
                  ),
                );
              } else {
                return wrapWithModel(
                  model: _model.paymentErrorModel,
                  updateCallback: () => safeSetState(() {}),
                  child: PaymentErrorWidget(
                    outcome: functions.outcomeText(
                                _model.decided, 'paymentStatus', '') !=
                            ''
                        ? _model.decided
                        : widget!.outcome,
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
