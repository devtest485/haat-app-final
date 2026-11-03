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

/// Asks for the passcode or a fingerprint before asking a customer for [amount] by
/// tap, QR or link.
///
/// Returns `{ok: true}` once given, `{}` when the dialog was closed.
Future<dynamic> haatConfirmItsYou(BuildContext context, String? amount) =>
    confirmItsYou(context, amount ?? '');
