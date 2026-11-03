// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/pay_request_flow.dart';

/// The payment request's QR, the business's logo in its middle; a quiet placeholder
/// until the request is made.
class PayRequestQr extends StatefulWidget {
  const PayRequestQr({
    super.key,
    this.width,
    this.height,
    this.request,
  });

  final double? width;
  final double? height;
  final dynamic request;

  @override
  State<PayRequestQr> createState() => _PayRequestQrState();
}

class _PayRequestQrState extends State<PayRequestQr> {
  @override
  Widget build(BuildContext context) =>
      PayRequestQrView(request: widget.request, size: widget.width ?? 173);
}
