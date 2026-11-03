// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/widgets/payout_screen.dart';

/// Closes the method sheet and opens a payout: the business's available money to its
/// own bank account, with the amount from the screen before already typed.
///
/// The navigator is taken before the sheet closes: once it has, the sheet's context
/// is gone.
Future haatOpenPayout(
  BuildContext context,
  String? initialAmount,
) async {
  final navigator = Navigator.of(context);
  navigator.pop();
  await navigator.push(
    MaterialPageRoute(
      builder: (_) => PayoutScreen(initialAmount: initialAmount),
    ),
  );
}
