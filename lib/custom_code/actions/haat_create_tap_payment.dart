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

/// Makes a tap to pay request for [amount].
///
/// Returns the request TapPayOut shows — code, invoice, amount, currency,
/// confirmOnPhone — or `{error}`, a sentence to show.
Future<dynamic> haatCreateTapPayment(String? amount) =>
    createTapPayment(amount ?? '');
