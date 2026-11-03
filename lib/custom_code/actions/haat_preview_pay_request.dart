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

/// What the request [code] asks for: who (name, handle, logo, verified), the invoice,
/// amount, fee and total, until when, and `blocker` — why it can't be paid, empty
/// when it can. `{error}` when HAAT can't say.
Future<dynamic> haatPreviewPayRequest(String? code) =>
    previewPayRequest(code ?? '');
