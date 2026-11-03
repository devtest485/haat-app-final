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

String pendingActionKeys(
  List<dynamic>? actions,
  String? seenActions,
) {
  // The keys already read plus the ones on screen now, comma-separated.
  final keys = (seenActions ?? '')
      .split(',')
      .map((s) => s.trim())
      .where((s) => s.isNotEmpty)
      .toSet();
  for (final a in actions ?? []) {
    final k = (a is Map ? a['key'] : null)?.toString() ?? '';
    if (k.isNotEmpty) keys.add(k);
  }
  return keys.join(',');
}
