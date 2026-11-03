// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/widgets/wallet_balance.dart';

/// Has the balance on the home screen read the wallet again now — after a send, so the
/// figure under the card is already the new one when the merchant gets back to it.
Future haatRefreshWallet() async {
  WalletBalance.refreshNow();
}
