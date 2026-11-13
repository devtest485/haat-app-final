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

/// Row subtitle: "<status label> · <time>".
///
/// [grouped] is true where the rows already sit under a date heading (All
/// Transactions), so only the time is shown; elsewhere (home) the day is
/// shown instead, as before.
String? transactionSubtitle(
  String? description,
  String? kind,
  String? occurredAt,
  String? direction,
  String? status,
  bool? grouped,
) {
  final at = DateTime.tryParse(occurredAt ?? '')?.toLocal();

  var day = '';
  if (at != null) {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final that = DateTime(at.year, at.month, at.day);
    final daysAgo = start.difference(that).inDays;

    day = daysAgo == 0
        ? 'Today'
        : daysAgo == 1
            ? 'Yesterday'
            : DateFormat(at.year == today.year ? 'd MMM' : 'd MMM y')
                .format(at);
  }
  final when = (grouped ?? false)
      ? (at == null ? '' : DateFormat('hh:mm a').format(at))
      : day;

  final given = (description ?? '').trim();
  final base = kind == 'transfer'
      ? ((direction ?? '').trim() == 'credit'
          ? 'Transfer received'
          : 'Transfer sent')
      : (given.isEmpty || given == 'null')
          ? ''
          : switch (kind) {
              'payment' => 'Payment received',
              'payout' => 'Payout',
              'release' => 'Funds released',
              'refund' => 'Refund',
              'fee' => 'Fee',
              _ => '',
            };

  final label = switch (transactionTone(kind, direction, status)) {
    'pending' => 'Pending',
    'failed' => 'Failed',
    'expired' => 'Expired',
    _ => base,
  };

  return [label, when].where((part) => part.isNotEmpty).join(' · ');
}
