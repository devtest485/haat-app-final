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

/// Checks the six-digit code. Empty when it was right, and the bank's details are then
/// ready for the confirm screen; otherwise the reason in words.
Future<String> haatSaibVerify(String? code) => BankLinkFlow.verify(code);
