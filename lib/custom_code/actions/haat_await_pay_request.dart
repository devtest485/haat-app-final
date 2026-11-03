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

/// Waits while the page is open until [request] is paid.
///
/// Returns the PaymentStatus outcome (`paymentStatus` Success), `{problem}` once the
/// request expired or was cancelled, or `{}` once the page closed.
Future<dynamic> haatAwaitPayRequest(BuildContext context, dynamic request) =>
    awaitPayRequest(context, request);
