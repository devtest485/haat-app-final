import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import '/flutter_flow/custom_functions.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/uploaded_file.dart';
import '/flutter_flow/ff_builtin_enums.dart';

/// What the cart comes to, in minor units, as a string — `"600000"` is 6,000 SDG.
///
/// Added as whole piastres in a BigInt, never as doubles: twelve lines at 0.10 must
/// come to 1.20 exactly.
String cartTotalMinor(List<dynamic>? cart) {
  var total = BigInt.zero;

  for (final line in cart ?? const []) {
    if (line is! Map) continue;
    final price = BigInt.tryParse('${line['priceMinor']}'.trim()) ?? BigInt.zero;
    final qty = int.tryParse('${line['qty']}') ?? 0;
    total += price * BigInt.from(qty);
  }

  return total.toString();
}
