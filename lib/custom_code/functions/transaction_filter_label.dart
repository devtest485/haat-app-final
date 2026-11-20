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

/// The filter sheet's button: "Show 12 transactions", counted the way the
/// list will show them — the period chip, then the sheet's choices, without
/// the bookkeeping lines the list hides.
String transactionFilterLabel(
  List<dynamic>? rows,
  int filterIndex,
  String? direction,
  String? status,
  String? method,
) {
  final groups = transactionDayGroups(
          filterTransactionsBy(rows, direction, status, method), filterIndex) ??
      [];
  final count = groups.fold<int>(
      0, (sum, group) => sum + ((group as Map)['rows'] as List).length);

  if (count == 0) return 'No transactions';
  return count == 1 ? 'Show 1 transaction' : 'Show $count transactions';
}
