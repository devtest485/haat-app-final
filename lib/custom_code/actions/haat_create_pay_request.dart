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

/// Makes a one-time payment QR ([link] false) or payment link for [amount].
///
/// Returns the request the page shows — code, link, invoice, amount, currency, the
/// business's name and logo — or `{error}`, a sentence to show.
Future<dynamic> haatCreatePayRequest(String? amount, bool? link) =>
    createPayRequest(amount: amount ?? '', link: link ?? false);
