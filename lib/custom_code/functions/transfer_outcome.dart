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

dynamic transferOutcome(
  int? statusCode,
  dynamic body,
  String? amountMinor,
  String? currency,
  String? transferReference,
  String? via,
) {
  // How a send ended, ready for the status screen: kind (success, held, rejected,
  // credential, error or offline), status (the screen to show), the headline figures,
  // the detail rows and the text Share copies. A credential the server refused is only
  // a message for the passcode sheet: nothing moved.
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
  final now = DateTime.now();
  final envelope = body is Map ? body : const {};
  final data = envelope['data'] is Map ? envelope['data'] as Map : const {};
  String text(dynamic v) => v == null || '$v' == 'null' ? '' : '$v'.trim();

  final sentCode =
      text(currency).isEmpty ? 'SDG' : text(currency).toUpperCase();
  String money(String minor, String code) {
    final placesOf = places[code] ?? 2;
    final value = BigInt.tryParse(minor) ?? BigInt.zero;
    final digits = value.abs().toString().padLeft(placesOf + 1, '0');
    final whole = digits
        .substring(0, digits.length - placesOf)
        .replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+$)'), (m) => '${m[1]},');
    final fraction =
        placesOf == 0 ? '' : '.${digits.substring(digits.length - placesOf)}';
    return '${value.isNegative ? '-' : ''}$whole$fraction';
  }

  String short(String id) => id.split('-').first.toUpperCase();
  String when(DateTime at) => DateFormat('d MMM y · HH:mm').format(at);
  Map<String, String> line(String label, String value) =>
      {'label': label, 'value': value};
  String share(String heading, List<Map<String, String>> lines) => [
        heading,
        for (final l in lines) '${l['label']}: ${l['value']}',
      ].join('\n');

  Map<String, dynamic> failed(String kind, String minor, String code, String id,
      DateTime at, String reason,
      {bool keepReference = false}) {
    final lines = [
      line('Amount', '$code ${money(minor, code)}'),
      line('Reference number', short(id)),
      line('Date & Time', when(at)),
      if (reason.isNotEmpty) line('Reason', reason),
    ];
    return {
      'kind': kind,
      'status': 'Error',
      'message': reason,
      'keepReference': keepReference,
      'title': 'Transfer failed',
      'amount': money(minor, code),
      'currency': code,
      'subtitle': reason,
      'details': lines,
      'shareText': share('HAAT transfer, not sent', lines),
    };
  }

  // No answer at all: the send may or may not have reached the server, so a retry
  // keeps the same reference and cannot send twice.
  if ((statusCode ?? 0) <= 0) {
    return failed(
        'offline',
        text(amountMinor),
        sentCode,
        text(transferReference),
        now,
        'Couldn’t reach HAAT. Check your connection and try again.',
        keepReference: true);
  }

  if (envelope['isSuccess'] != true || text(data['transactionId']).isEmpty) {
    final message = text(envelope['message']).isEmpty
        ? 'The transfer didn’t go through.'
        : text(envelope['message']);
    final field = text(data['field']);
    if (field == 'passcode' || field == 'biometric') {
      return {
        'kind': 'credential',
        'status': '',
        'message': message,
        'keepReference': true,
      };
    }
    // Any other refusal means nothing was made: the next attempt is a new send.
    return failed('error', text(amountMinor), sentCode, text(transferReference),
        now, message);
  }

  final code = text(data['currency']).isEmpty
      ? sentCode
      : text(data['currency']).toUpperCase();
  final status = text(data['status']);
  final id = text(data['transactionId']);
  final at = DateTime.tryParse(text(data['occurredAt']))?.toLocal() ?? now;
  final minor = text(data['amountMinor']);
  final fee = BigInt.tryParse(text(data['feeMinor'])) ?? BigInt.zero;
  final name = text(data['recipientName']);
  final username = text(data['recipientUsername']);
  final mobile = text(data['recipientMobileMasked']);

  if (status == 'rejected') {
    return failed('rejected', minor, code, id, at, text(data['reason']));
  }

  if (status == 'held') {
    final lines = [
      line('Amount', '$code ${money(minor, code)}'),
      if (fee > BigInt.zero)
        line('Fee', '$code ${money(fee.toString(), code)}'),
      line('From', 'HAAT wallet'),
      line(
          'To Account',
          username.isNotEmpty
              ? '@$username'
              : (mobile.isNotEmpty ? mobile : text(via))),
      line('Reference number', short(id)),
      line('Receiver Name', name),
      line('Date & Time', when(at)),
    ];
    return {
      'kind': 'held',
      'status': 'Pending',
      'keepReference': false,
      'title': 'Waiting for approval',
      'amount': money(minor, code),
      'currency': code,
      'subtitle': '$name · HAAT transfer',
      'details': lines,
      'shareText': share('HAAT transfer, waiting for approval', lines),
    };
  }

  final note = text(data['note']);
  final lines = [
    if (username.isNotEmpty) line('Username', '@$username'),
    if (mobile.isNotEmpty) line('Mobile number', mobile),
    if (fee > BigInt.zero) ...[
      line('Fee', '$code ${money(fee.toString(), code)}'),
      line('Total from wallet',
          '$code ${money(text(data['totalMinor']), code)}'),
    ],
    if (note.isNotEmpty) line('Note', note),
    line('Reference number', short(id)),
    line('Date & time', when(at)),
  ];
  return {
    'kind': 'success',
    'status': 'Success',
    'keepReference': false,
    'title': 'Money sent',
    'amount': money(minor, code),
    'currency': code,
    'subtitle': '$name · HAAT transfer',
    'details': lines,
    'shareText': share(
        'HAAT transfer\nSent $code ${money(minor, code)} to $name', lines),
  };
}
