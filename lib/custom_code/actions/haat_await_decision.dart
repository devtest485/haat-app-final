// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/held_payment.dart';

/// Waits, while the Pending screen is open, for the admin to approve or refuse a held
/// payment; [outcome] is the Pending outcome.
///
/// Returns the outcome for the Success screen once approved, for the Error screen
/// once refused, or `{}` once the page closed.
Future<dynamic> haatAwaitDecision(
  BuildContext context,
  dynamic outcome,
) =>
    awaitHeldDecision(context, outcome);
