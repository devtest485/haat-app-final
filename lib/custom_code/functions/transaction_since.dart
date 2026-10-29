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

/// ISO start date for the transactions chip filter (0 = all time)
String transactionSince(int filter) {
  final days = filter == 1
      ? 7
      : filter == 2
          ? 30
          : filter == 3
              ? 90
              : 0;
  if (days == 0) return '2000-01-01T00:00:00Z';
  final d = DateTime.now().toUtc().subtract(Duration(days: days));
  return d.toIso8601String().substring(0, 19) + 'Z';
}
