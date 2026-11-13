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

/// How the money on a statement line moved, for the badge on its icon and the
/// Method filter.
///
/// tap | qr | link — how a customer paid; user — a transfer to or from another
/// merchant, found by username or mobile; bank — a payout to a bank account
/// (and the hold set aside for it); topup — funds added. Empty when none fits.
String transactionMethod(dynamic row) {
  if (row is! Map) return '';
  final kind = (row['kind'] ?? '').toString().trim();

  // A wallet paying another merchant's tap, QR or link request moves as a transfer
  // too, but the line keeps how it was paid. Only a plain Transfer is `user`.
  final method = (row['paymentMethod'] ?? '').toString().trim();
  if (method == 'tap' || method == 'qr' || method == 'link') return method;

  if (row['transfer'] is Map || kind == 'transfer') return 'user';
  if (kind == 'payout') return 'bank';
  if (kind == 'hold' &&
      (row['description'] ?? '').toString().toLowerCase().contains('payout')) {
    return 'bank';
  }
  if (kind == 'topup') return 'topup';

  return '';
}
