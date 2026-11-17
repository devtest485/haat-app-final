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

dynamic transactionOutcome(dynamic row) {
  // A statement line, ready for the status screen: Success, Pending or Error by the line's
  // own status, with the headline figures, the detail rows and the text Share copies.
  if (row is! Map) return <String, dynamic>{};
  String text(dynamic v) => v == null || '$v' == 'null' ? '' : '$v'.trim();

  final kind = text(row['kind']);
  final direction = text(row['direction']);
  final incoming = direction == 'credit';
  final tone = transactionTone(kind, direction, text(row['status']));
  final paymentStatus = const ['pending', 'held'].contains(tone)
      ? 'Pending'
      : const ['failed', 'declined', 'expired'].contains(tone)
          ? 'Error'
          : 'Success';

  const places = {
    'LYD': 3,
    'KWD': 3,
    'BHD': 3,
    'OMR': 3,
    'TND': 3,
    'JOD': 3,
    'IQD': 3,
    'JPY': 0,
  };
  final code = text(row['currency']).isEmpty
      ? 'SDG'
      : text(row['currency']).toUpperCase();
  final placesOf = places[code] ?? 2;
  final value = BigInt.tryParse(text(row['amountMinor'])) ?? BigInt.zero;
  final digits = value.abs().toString().padLeft(placesOf + 1, '0');
  final whole = digits
      .substring(0, digits.length - placesOf)
      .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');
  final fraction =
      placesOf == 0 ? '' : '.${digits.substring(digits.length - placesOf)}';
  final amount = '$whole$fraction';

  final transfer = row['transfer'] is Map ? row['transfer'] as Map : null;
  final other = text(transfer?[incoming ? 'fromName' : 'toName']);
  final method = switch (transactionMethod(row)) {
    'tap' => 'Tap to Pay',
    'qr' => 'QR Code',
    'link' => 'Payment link',
    'user' => 'HAAT transfer',
    'bank' => 'Bank transfer',
    'topup' => 'Add funds',
    _ => '',
  };

  final title = switch (paymentStatus) {
    'Pending' => incoming ? 'Waiting for payment' : 'Waiting for approval',
    'Error' => incoming ? 'Payment failed' : 'Transfer failed',
    _ => switch (kind) {
        'payment' => 'Payment received',
        'refund' => 'Refund',
        'fee' => 'Fee charged',
        'payout' => 'Payout sent',
        'release' => 'Funds released',
        _ => incoming ? 'Money received' : 'Money sent',
      },
  };
  final subtitle = [
    if (other.isNotEmpty)
      other
    else
      text(transactionTitle(
          text(row['description']), kind, direction, transfer)),
    if (method.isNotEmpty) method,
  ].join(' · ');

  final at = DateTime.tryParse(text(row['occurredAt']))?.toLocal();
  final reference = text(row['reference']).isNotEmpty
      ? text(row['reference'])
      : text(row['transactionId']).split('-').first.toUpperCase();
  final account = other.isNotEmpty
      ? other
      : (text(row['description']).isNotEmpty
          ? text(row['description'])
          : 'HAAT wallet');

  Map<String, String> line(String label, String v) =>
      {'label': label, 'value': v};
  final lines = [
    line('Amount', '$code $amount'),
    line('From', incoming ? account : 'HAAT wallet'),
    line('To Account', incoming ? 'HAAT wallet' : account),
    if (reference.isNotEmpty) line('Reference number', reference),
    if (method.isNotEmpty) line('Method', method),
    if (at != null)
      line('Date & Time', DateFormat('d MMM y · HH:mm').format(at)),
  ];

  return <String, dynamic>{
    'paymentStatus': paymentStatus,
    'title': title,
    'amount': amount,
    'currency': code,
    'subtitle': subtitle,
    'status': paymentStatus,
    'details': lines,
    'shareText': [
      'HAAT · $title\n$code $amount',
      for (final l in lines) '${l['label']}: ${l['value']}',
    ].join('\n'),
  };
}
