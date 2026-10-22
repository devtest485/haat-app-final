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

/// The grey line under a statement row: `Payment received · Today`.
///
/// The kind is left out when the headline already is the kind (a posting with no
/// description), so the row never says the same thing twice.
String transactionSubtitle(
  String? description,
  String? kind,
  String? occurredAt,
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

  final given = (description ?? '').trim();
  if (given.isEmpty || given == 'null') return day;

  final label = switch (kind) {
    'payment' => 'Payment received',
    'payout' => 'Payout',
    'release' => 'Funds released',
    'refund' => 'Refund',
    'fee' => 'Fee',
    _ => '',
  };

  return [label, day].where((part) => part.isNotEmpty).join(' · ');
}
