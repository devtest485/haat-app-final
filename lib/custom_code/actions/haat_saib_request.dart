// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/bank_link_flow.dart';

/// Asks the bank to send a code to the phone it has on file for the account typed on
/// Link your SIB account. Empty when the code is on its way; otherwise the reason in words,
/// including "we could not find a SIB account" for numbers that are not this business's.
Future<String> haatSaibRequest(
  String? number,
  String? phone,
) =>
    BankLinkFlow.request(number, phone);
