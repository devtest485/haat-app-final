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

String? transactionTitle(
  String? description,
  String? kind, [
  String? direction,
  dynamic transfer,
]) {
  // One merchant's send to another is a single movement with one description, written
  // from the sender's side. Each side reads it as the other person's name.
  if (transfer is Map) {
    final outgoing = (direction ?? '').trim() != 'credit';
    final name = '${transfer[outgoing ? 'toName' : 'fromName'] ?? ''}'.trim();
    if (name.isNotEmpty) return outgoing ? 'To $name' : 'From $name';
  }

  final given = (description ?? '').trim();
  if (given.isNotEmpty && given != 'null') return given;

  switch (kind) {
    case 'payment':
      return 'Payment received';
    case 'payout':
      return 'Payout';
    case 'release':
      return 'Funds released';
    case 'refund':
      return 'Refund';
    case 'fee':
      return 'Fee';
    case 'transfer':
      return 'Transfer';
    default:
      return 'Transaction';
  }
}
