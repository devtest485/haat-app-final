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

/// Narrows the statement to the All Transactions filter sheet's choices.
///
/// direction: All | Incoming | Outgoing. status: All | Successful | Pending |
/// Failed — read through [transactionTone], so the filter and the row icons
/// always agree; held money counts as Pending, declined, reversed and expired
/// as Failed. method: All types | Tap to Pay | QR Code | Payment link |
/// Transfer | Add funds — read through [transactionMethod]; Transfer covers
/// both a merchant and a bank account.
List<dynamic> filterTransactionsBy(
  List<dynamic>? rows,
  String? direction,
  String? status,
  String? method,
) {
  String field(dynamic r, String key) {
    final value = r is Map ? r[key] : null;
    return value == null ? '' : value.toString().trim();
  }

  bool directionMatches(dynamic r) {
    final incoming = field(r, 'direction') == 'credit';
    switch ((direction ?? 'All').trim()) {
      case 'Incoming':
        return incoming;
      case 'Outgoing':
        return !incoming;
      default:
        return true;
    }
  }

  bool statusMatches(dynamic r) {
    final chip = (status ?? 'All').trim();
    if (chip.isEmpty || chip == 'All') return true;
    final bucket = switch (transactionTone(
        field(r, 'kind'), field(r, 'direction'), field(r, 'status'))) {
      'pending' || 'held' => 'Pending',
      'failed' || 'declined' || 'expired' => 'Failed',
      _ => 'Successful',
    };
    return bucket == chip;
  }

  bool methodMatches(dynamic r) {
    final how = transactionMethod(r);
    switch ((method ?? 'All types').trim()) {
      case 'Tap to Pay':
        return how == 'tap';
      case 'QR Code':
        return how == 'qr';
      case 'Payment link':
        return how == 'link';
      case 'Transfer':
        return how == 'user' || how == 'bank';
      case 'Add funds':
        return how == 'topup';
      default:
        return true;
    }
  }

  return (rows ?? [])
      .where((r) => directionMatches(r) && statusMatches(r) && methodMatches(r))
      .toList();
}
