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

/// The customer turns request [code] down on their own phone — closing the approval
/// page without paying. A tap the merchant is waiting on ends there as declined; a
/// request that is not a tap, or is already paid, is left alone.
Future haatDeclinePayRequest(String? code) async {
  declinePayRequest(code ?? '');
}
