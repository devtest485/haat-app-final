// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/payout_flow.dart';

/// Sends the amount from the wallet to the linked bank account, once the passcode sheet
/// has the passcode, and answers with how it ended — for the passcode sheet when the
/// passcode was wrong, otherwise for the Success, Pending or Error screen.
///
/// Nearly always Pending: the money is set aside at once and HAAT sends it, which turns
/// the Pending screen into Success.
Future<dynamic> haatSendPayout(
  String? passcode,
  String? amountMinor,
  String? currency,
  String? reference,
  String? name,
  String? via,
) =>
    PayoutFlow.send(
      passcode: passcode,
      amountMinor: amountMinor,
      currency: currency,
      reference: reference,
      name: name,
      via: via,
    );
