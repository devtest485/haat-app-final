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

/// The Profile tab's figures, as JSON the page binds to: `name`, `handle`, `logoPath`,
/// `orders`, `products`, `staff`, `productsLine`, `staffLine`, `branchesLine`, `kybLine`.
///
/// Null when the account has no business yet or the server could not be reached; the
/// page then shows dashes rather than another business's numbers.
Future<dynamic> haatStoreProfile() async {
  final profile = await AuthSession.instance.storeProfile.load();
  return profile?.toJson();
}
