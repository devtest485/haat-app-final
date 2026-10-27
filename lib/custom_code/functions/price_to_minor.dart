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

String priceToMinor(String? price) {
  final clean = (price ?? '').replaceAll(',', '').trim();
  final parts = clean.split('.');
  final major = BigInt.tryParse(parts.first.isEmpty ? '0' : parts.first);
  if (major == null) return '0';
  final cents = parts.length > 1
      ? parts[1].padRight(2, '0').substring(0, 2)
      : '00';

  return (major * BigInt.from(100) + (BigInt.tryParse(cents) ?? BigInt.zero))
      .toString();
}
