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

List<dynamic> filterTransactions(
  List<dynamic>? rows,
  String? query,
) {
  final words = (query ?? '')
      .toLowerCase()
      .split(RegExp(r'\s+'))
      .map((w) => w.replaceAll(',', ''))
      .where((w) => w.isNotEmpty)
      .toList();
  if (words.isEmpty) return (rows ?? []).toList();

  String field(dynamic r, String key) {
    final value = r is Map ? r[key] : null;
    return value == null ? '' : value.toString();
  }

  String haystack(dynamic r) {
    final at = DateTime.tryParse(field(r, 'occurredAt'))?.toLocal();
    final minor = BigInt.tryParse(field(r, 'amountMinor')) ?? BigInt.zero;
    final whole = (minor ~/ BigInt.from(100)).toString();
    final kind = field(r, 'kind');
    return [
      transactionTitle(field(r, 'description'), kind) ?? '',
      kind,
      field(r, 'reference'),
      field(r, 'paymentMethod'),
      field(r, 'currency'),
      field(r, 'direction') == 'credit'
          ? 'received incoming in'
          : 'sent outgoing out',
      transactionAmount(field(r, 'amountMinor'), field(r, 'currency'),
              field(r, 'direction')) ??
          '',
      whole,
      at == null ? '' : DateFormat('d/M/yy d MMM MMMM y').format(at),
    ].join(' ').toLowerCase().replaceAll(',', '');
  }

  return (rows ?? []).where((r) {
    final text = haystack(r);
    return words.every(text.contains);
  }).toList();
}
