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

List<dynamic> latestTransactions(
  List<dynamic>? rows,
  int? count,
) {
// The newest statement lines the home list shows, count of them. The book-keeping
// lines a held send leaves behind (hold_release, the hold's credit side) are never
// drawn, so they are dropped first — otherwise they use up a place and the list
// shows fewer than count.
  bool hiddenLine(dynamic r) {
    if (r is! Map) return true;
    final k = (r['kind'] ?? '').toString().trim();
    return k == 'hold_release' ||
        (k == 'hold' && (r['direction'] ?? '').toString().trim() == 'credit');
  }

  return (rows ?? []).where((r) => !hiddenLine(r)).take(count ?? 3).toList();
}
