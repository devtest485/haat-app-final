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

/// Narrows the statement to one status chip: All, Paid, Pending, Failed or
/// Expired.
///
/// A row's status is read through [transactionTone], so the chips and the row
/// icons always agree. Held money counts as Pending, declined/reversed as
/// Failed.
List<dynamic> filterTransactionsByStatus(
  List<dynamic>? rows,
  String? status,
) {
  final all = (rows ?? []).toList();
  final chip = (status ?? 'All').trim();
  if (chip.isEmpty || chip == 'All') return all;

  String field(dynamic r, String key) {
    final value = r is Map ? r[key] : null;
    return value == null ? '' : value.toString();
  }

  String bucket(dynamic r) {
    switch (transactionTone(
        field(r, 'kind'), field(r, 'direction'), field(r, 'status'))) {
      case 'pending':
      case 'held':
        return 'Pending';
      case 'failed':
      case 'declined':
        return 'Failed';
      case 'expired':
        return 'Expired';
      default:
        return 'Paid';
    }
  }

  return all.where((r) => bucket(r) == chip).toList();
}
