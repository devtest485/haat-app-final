// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/api_result.dart';
import '/custom_code/auth_session.dart';
import '/custom_code/transaction_api.dart';

/// Whether the business has traded at all.
///
/// The transactions screen was drawn with two faces and a page-state boolean to choose
/// between them — and nothing ever set the boolean, so every merchant got the empty
/// one, including the screen's own list of five rows which no one could reach.
///
/// This answers the question on the way in, from the merchant's own books. One line is
/// enough to know, so it asks for one.
///
/// False when the call fails, which is the same face a merchant with nothing sees. The
/// alternative — showing an empty list under a filter bar — is a screen that looks
/// broken rather than a screen that says there is nothing yet.
Future<bool> haatHasTransactions() async {
  final result = await AuthSession.instance.transactions.list(limit: 1);

  if (result is! ApiSuccess<List<MerchantTransaction>>) return false;

  final any = result.value.isNotEmpty;

  // Kept in App State as well, because the list widget on the same screen writes it
  // after its own fetch and the two must not disagree.
  FFAppState().update(() => FFAppState().hasTransactions = any);

  return any;
}
