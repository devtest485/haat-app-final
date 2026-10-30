// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/auth_session.dart';
import '/custom_code/business_summary_api.dart';

/// The My Business tab's figures for `Day`, `Week` or `Month`, as JSON the page binds
/// to: `total`, `change`, `values`, `labels`, and per channel (`qr`, `nfc`, `link`)
/// `{Channel}Count` and `{Channel}Share`.
///
/// Every figure on that tab was the design's — +30,000 SDG, 693 QR payments — the
/// same for every merchant. Zeros and an empty `change` before the first sale.
Future<dynamic> haatBusinessSummary(String? period) async {
  final summary = await AuthSession.instance.businessSummary.load(
    (period ?? 'Week').toLowerCase(),
  );
  return (summary ?? BusinessSummary.empty((period ?? 'Week').toLowerCase()))
      .toJson(FFAppState().languageCode);
}
