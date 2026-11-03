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

List<dynamic> statusDetails(
  dynamic outcome,
  String? kind,
) {
  // The label and value lines under a status: the send's own, or, without one, the
  // design's sample lines for that screen (success, pending or error).
  final given = outcome is Map ? outcome['details'] : null;
  if (given is List && given.isNotEmpty) {
    return given
        .whereType<Map>()
        .map((l) => Map<String, dynamic>.from(l))
        .toList();
  }

  List<dynamic> lines(List<List<String>> rows) => [
        for (final r in rows) {'label': r[0], 'value': r[1]}
      ];
  switch ((kind ?? '').trim().toLowerCase()) {
    case 'pending':
      return lines([
        ['Amount', '10,000,000 SDG'],
        ['From', 'HAAT wallet'],
        ['To Account', '@ahmed_liipper'],
        ['Reference number', 'HT-2610-1709-4155'],
        ['Receiver Name', 'Ahmed Liipper'],
        ['Date & Time', '17 Oct 2026 · 09:41'],
      ]);
    case 'error':
      return lines([
        ['Amount', '10,000,000 SDG'],
        ['Reference number', 'HT-2610-1709-4155'],
        ['Date & Time', '17 Oct 2026 · 09:41'],
      ]);
    default:
      return lines([
        ['Mobile number', '+249 ··· ··· 910'],
        ['Reference number', 'HT-2610-1709-4155'],
        ['Date & time', '17 Oct 2026 · 09:41'],
      ]);
  }
}
