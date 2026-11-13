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

/// Row subtitle after the status word: "Tap to Pay · 09:41 AM".
///
/// Pending, held, failed, declined and expired lines get only the time, as the
/// row puts its own coloured "Pending" / "Failed" / "Expired" in front of it.
/// [grouped] is true where the rows already sit under a date heading (All
/// Transactions), so only the time is shown; elsewhere (home) the day is.
String transactionRowSubtitle(
  dynamic row,
  bool? grouped,
) {
  if (row is! Map) return '';
  final kind = (row['kind'] ?? '').toString().trim();
  final direction = (row['direction'] ?? '').toString().trim();
  final status = (row['status'] ?? '').toString().trim();

  final at = DateTime.tryParse((row['occurredAt'] ?? '').toString())?.toLocal();
  var when = '';
  if (at != null) {
    if (grouped ?? false) {
      when = DateFormat('hh:mm a').format(at);
    } else {
      final today = DateTime.now();
      final daysAgo = DateTime(today.year, today.month, today.day)
          .difference(DateTime(at.year, at.month, at.day))
          .inDays;
      when = daysAgo == 0
          ? 'Today'
          : daysAgo == 1
              ? 'Yesterday'
              : DateFormat(at.year == today.year ? 'd MMM' : 'd MMM y')
                  .format(at);
    }
  }

  final tone = transactionTone(kind, direction, status);
  if (const ['pending', 'held', 'failed', 'declined', 'expired']
      .contains(tone)) {
    return when;
  }

  final label = switch (transactionMethod(row)) {
    'tap' => 'Tap to Pay',
    'qr' => 'QR Code',
    'link' => 'Payment link',
    'user' => 'Transfer',
    'bank' => 'Bank transfer',
    'topup' => 'Add funds',
    _ => switch (kind) {
        'payment' => 'Payment',
        'release' => 'Funds released',
        'refund' => 'Refund',
        'fee' => 'Fee',
        _ => '',
      },
  };

  return [label, when].where((part) => part.isNotEmpty).join(' · ');
}
