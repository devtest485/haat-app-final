// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/pay_request_flow.dart' show openPayRequest;
import '/custom_code/pay_request_screens.dart';

/// Opens the scanner for another business's HAAT payment QR. What it reads is only a
/// code: who is paid and how much come from HAAT, and nothing is paid until approved.
Future haatOpenPayScanner(BuildContext context) async {
  final code = await Navigator.of(context).push<String>(
    MaterialPageRoute(builder: (_) => const PayScannerScreen()),
  );
  if (code != null && context.mounted) openPayRequest(context, code);
}
