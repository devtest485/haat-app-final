import '/backend/api_requests/api_calls.dart';
import '/components/transfer_auth_widget.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'payment_review_widget.dart' show PaymentReviewWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PaymentReviewModel extends FlutterFlowModel<PaymentReviewWidget> {
  ///  Local state fields for this page.

  String currency = 'SDG';

  String available = '';

  String transferReference = '';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - haatAccessToken] action in PaymentReview widget.
  String? token;
  // Stores action output result for [Backend Call - API (Wallet)] action in PaymentReview widget.
  ApiCallResponse? wallet;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
