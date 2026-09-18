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
/// Reads the list rather than `selectedSalesChannel`, which holds only the first
/// key: the screen is multi-select — the design shows two channels ticked and a
/// "Continue (2)" beside them — and the two are written together, so the list is
/// the one that answers "has anything been chosen".
///
/// Empty-means-yes matches every other action here — the caller compares against
/// '' and shows whatever else it gets.
Future<String> haatSalesChannelChosen() async =>
    FFAppState().selectedSalesChannels.isEmpty
        ? 'Choose where you sell to continue.'
        : '';
