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

String formatMinor(
  String? minor,
  String? currency,
) {
  // Minor units as a person reads them: "SDG 12,300.50". String arithmetic on a BigInt,
  // so a balance past what a double holds exactly still shows every digit.
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
  final code = (currency ?? '').trim().isEmpty || currency == 'null'
      ? 'SDG'
      : currency!.trim().toUpperCase();
  final placesOf = places[code] ?? 2;
  final value = BigInt.tryParse((minor ?? '').trim()) ?? BigInt.zero;
  final digits = value.abs().toString().padLeft(placesOf + 1, '0');
  final whole = digits
      .substring(0, digits.length - placesOf)
      .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');
  final fraction =
      placesOf == 0 ? '' : '.${digits.substring(digits.length - placesOf)}';

  return '$code ${value.isNegative ? '-' : ''}$whole$fraction';
}
