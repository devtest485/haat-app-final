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

String productFormError(
  String? name,
  String? price,
  String? unit,
  String? quantity,
  bool? outOfStock,
) {
  final cleanName = (name ?? '').trim();
  if (cleanName.isEmpty) return 'Enter the product name.';
  if (cleanName.length > 80) return 'Keep the name to 80 characters or fewer.';

  final cleanPrice = (price ?? '').replaceAll(',', '').trim();
  if (cleanPrice.isEmpty) return 'Enter the price in SDG.';
  if (!RegExp(r'^\d{1,13}(\.\d{1,2})?$').hasMatch(cleanPrice)) {
    return 'Enter the price as a number, like 3000 or 3000.50.';
  }
  if (double.parse(cleanPrice) <= 0) return 'Enter a price above zero.';

  if ((unit ?? '').trim().length > 40) {
    return 'Keep the size to 40 characters or fewer.';
  }

  final cleanQuantity = (quantity ?? '').trim();
  if (outOfStock == true || cleanQuantity.isEmpty) return '';
  final count = int.tryParse(cleanQuantity);
  if (count == null || count < 0 || count > 1000000000) {
    return 'Enter how many you have as a whole number, zero or more.';
  }
  if (count == 0 && outOfStock == false) {
    return 'Enter how many you have left, or choose Out of stock.';
  }
  return '';
}
