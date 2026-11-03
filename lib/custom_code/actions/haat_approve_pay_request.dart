// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/pay_request_flow.dart';

/// Asks for the passcode or a fingerprint over the request in [preview], then pays it.
///
/// Returns the PaymentStatus outcome with `paymentStatus` Success, Pending or Error,
/// or `{}` when the person closed the dialog.
Future<dynamic> haatApprovePayRequest(BuildContext context, dynamic preview) =>
    approvePayRequest(context, preview);
