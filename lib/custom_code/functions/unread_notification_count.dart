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

int unreadNotificationCount(
  dynamic body,
  String? seenActions,
) {
  // Unread feed items, plus pending actions not marked read on this phone. Adding the
  // team is a suggestion, not news, so it never counts.
  final data = body is Map ? body['data'] : null;
  if (data is! Map) return 0;
  final read = (seenActions ?? '').split(',').map((s) => s.trim()).toSet();
  var n = 0;
  for (final a in (data['actions'] is List ? data['actions'] as List : [])) {
    final k = (a is Map ? a['key'] : null)?.toString() ?? '';
    if (k.isNotEmpty && k != 'add_team' && !read.contains(k)) n++;
  }
  for (final group in ['today', 'earlier']) {
    for (final i in (data[group] is List ? data[group] as List : [])) {
      if (i is Map && i['unread'] == true) n++;
    }
  }
  return n;
}
