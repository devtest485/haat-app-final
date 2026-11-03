import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/payment_status/payment_error/payment_error_widget.dart';
import '/payment_status/payment_pending/payment_pending_widget.dart';
import '/payment_status/payment_success/payment_success_widget.dart';
import 'payment_status_widget.dart' show PaymentStatusWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PaymentStatusModel extends FlutterFlowModel<PaymentStatusWidget> {
  ///  State fields for stateful widgets in this page.

  // Model for PaymentSuccess component.
  late PaymentSuccessModel paymentSuccessModel;
  // Model for PaymentPending component.
  late PaymentPendingModel paymentPendingModel;
  // Model for PaymentError component.
  late PaymentErrorModel paymentErrorModel;

  @override
  void initState(BuildContext context) {
    paymentSuccessModel = createModel(context, () => PaymentSuccessModel());
    paymentPendingModel = createModel(context, () => PaymentPendingModel());
    paymentErrorModel = createModel(context, () => PaymentErrorModel());
  }

  @override
  void dispose() {
    paymentSuccessModel.dispose();
    paymentPendingModel.dispose();
    paymentErrorModel.dispose();
  }
}
