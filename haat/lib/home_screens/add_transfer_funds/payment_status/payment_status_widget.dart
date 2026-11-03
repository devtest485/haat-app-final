import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/payment_status/payment_error/payment_error_widget.dart';
import '/payment_status/payment_pending/payment_pending_widget.dart';
import '/payment_status/payment_success/payment_success_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'payment_status_model.dart';
export 'payment_status_model.dart';

class PaymentStatusWidget extends StatefulWidget {
  const PaymentStatusWidget({
    super.key,
    required this.paymentStatus,
  });

  final String? paymentStatus;

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
              if (widget!.paymentStatus == 'Success') {
                return wrapWithModel(
                  model: _model.paymentSuccessModel,
                  updateCallback: () => safeSetState(() {}),
                  child: PaymentSuccessWidget(),
                );
              } else if (widget!.paymentStatus == 'Pending') {
                return wrapWithModel(
                  model: _model.paymentPendingModel,
                  updateCallback: () => safeSetState(() {}),
                  child: PaymentPendingWidget(),
                );
              } else {
                return wrapWithModel(
                  model: _model.paymentErrorModel,
                  updateCallback: () => safeSetState(() {}),
                  child: PaymentErrorWidget(),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
