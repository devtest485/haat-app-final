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

/// The Orders page: the business's paid sales with one of its own products in them,
/// newest first, as JSON the page binds to — `ok` (false when they could not be
/// loaded) and `orders`, each with `title`, `items`, `amount`, `paidBy`, `when` and
/// `lines` (`name`, `quantity`, `amount`).
Future<dynamic> haatLoadOrders() async {
  final orders = await AuthSession.instance.orders.mine();
  final now = DateTime.now();
  return {
    'ok': orders != null,
    'orders': [for (final order in orders ?? const []) order.toJson(now)],
  };
}
