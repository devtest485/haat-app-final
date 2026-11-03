// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/sale_cart.dart';

/// Remembers what is being charged before the pay-out sheet opens: the cart when the
/// sale was built from products, null when it was typed on the keypad. The QR, link or
/// tap made next carries the cart as its lines, so the sale shows in Orders.
Future haatSetSaleCart(List<dynamic>? cart) async {
  SaleCart.set(cart);
}
