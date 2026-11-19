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

/// Reads the business's linked bank account into App State, so the home screen can show
/// its number under the wallet number and the Transfer sheet knows whether one is linked.
Future haatLoadBankLinks() => BankLinkFlow.refresh(force: true);
