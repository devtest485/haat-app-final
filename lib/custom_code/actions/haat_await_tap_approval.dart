// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/tap_to_pay.dart';

/// Waits, while the page is open, for the customer to approve [request] on their
/// phone; [tapped] is what the tap said about them (payerName, payerMobileMasked).
///
/// Returns the PaymentStatus outcome once paid, `{problem}` once it expired or was
/// cancelled, or `{}` once the page closed.
Future<dynamic> haatAwaitTapApproval(
  BuildContext context,
  dynamic request,
  dynamic tapped,
) =>
    awaitTapApproval(context, request, tapped);
