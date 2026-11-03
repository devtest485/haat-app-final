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

List<dynamic>? transactionDayGroups(
  List<dynamic>? rows,
  int filter,
) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final days = filter == 1
      ? 7
      : filter == 2
          ? 30
          : filter == 3
              ? 90
              : 0;
  DateTime? at(dynamic r) =>
      DateTime.tryParse((r['occurredAt'] ?? '').toString())?.toLocal();
  int ago(DateTime d) =>
      today.difference(DateTime(d.year, d.month, d.day)).inDays;
  String label(dynamic r) => at(r) == null
      ? ''
      : ago(at(r)!) == 0
          ? 'TODAY'
          : ago(at(r)!) == 1
              ? 'YESTERDAY'
              : DateFormat('d/M/yy').format(at(r)!);
  final shown = (rows ?? [])
      .where((r) =>
          days == 0 ||
          (at(r) != null && at(r)!.isAfter(now.subtract(Duration(days: days)))))
      .take(days == 0 ? 20 : 1000)
      .toList();
  return shown
      .map(label)
      .toSet()
      .map((l) => Map.fromEntries([
            MapEntry('label', l),
            MapEntry('rows', shown.where((r) => label(r) == l).toList())
          ]))
      .toList();
}
