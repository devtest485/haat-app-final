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

/// Reads the customer's phone over NFC and charges [request] to it, while the page
/// is open.
///
/// Returns the PaymentStatus outcome once paid, `{confirm: true}` when the customer
/// approves on their phone instead, `{problem}` when it cannot go on, or `{}` once
/// the page closed.
Future<dynamic> haatTapToPay(BuildContext context, dynamic request) =>
    tapToPay(context, request);
