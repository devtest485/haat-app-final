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

String toMinorUnits(
  String? amount,
  String? currency,
) {
  // What was typed, as whole minor units — "125.5" in SDG is "12550" — or empty.
  //
  // Joined as digits, never multiplied, so 0.1 is ten piastres and not a float's guess.
  // Refuses rather than rounds a figure with more places than the currency has, and
  // refuses zero, since nothing is not an amount to send.
  const places = {
    'LYD': 3,
    'KWD': 3,
    'BHD': 3,
    'OMR': 3,
    'TND': 3,
    'JOD': 3,
    'IQD': 3,
    'JPY': 0,
  };
  final placesOf = places[(currency ?? '').trim().toUpperCase()] ?? 2;
  final cleaned = (amount ?? '').trim().replaceAll(',', '');
  final shape = placesOf == 0
      ? RegExp(r'^(\d+)$')
      : RegExp('^(\\d+)(?:\\.(\\d{1,$placesOf}))?\$');
  final match = shape.firstMatch(cleaned);
  if (match == null) return '';

  final minor =
      BigInt.parse('${match[1]}${(match[2] ?? '').padRight(placesOf, '0')}');
  return minor == BigInt.zero ? '' : minor.toString();
}
