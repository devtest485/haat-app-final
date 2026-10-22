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

/// A home banner's card colour from the back office's `#rrggbb`, or HAAT green
/// when the value is missing or not a colour.
Color bannerBackground(String? hex) {
  final digits = (hex ?? '').trim().replaceFirst('#', '');
  final value = digits.length == 6 ? int.tryParse(digits, radix: 16) : null;

  return value == null ? const Color(0xFF005A3B) : Color(0xFF000000 | value);
}
