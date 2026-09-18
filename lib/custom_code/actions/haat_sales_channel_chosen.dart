// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

/// Whether the merchant has picked where they sell. Empty means they have.
///
/// One choice, not several: the screen shows a radio beside each row and
/// `PATCH /organizations` takes a single `salesChannel`. The screen's own subtitle
/// used to say "choose as many as you want", which agreed with neither.
///
/// Empty-means-yes matches every other action here — the caller compares against
/// '' and shows whatever else it gets.
Future<String> haatSalesChannelChosen() async =>
    FFAppState().selectedSalesChannel.isEmpty
        ? 'Choose where you sell to continue.'
        : '';
