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

/// A statement line's headline: its own description, or what kind of movement it was
/// when the posting carried none.
String transactionTitle(
  String? description,
  String? kind,
) {
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
    default:
      return 'Transaction';
  }
}
