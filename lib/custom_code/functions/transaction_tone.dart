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

String transactionTone(
  String? kind,
  String? direction,
  String? status,
) {
  final k = (kind ?? '').trim();
  final s = (status ?? '').trim();
  // A held send moves money into the business's own held account and, if it is turned
  // down, back out again. Only the send's line is shown.
  if (k == 'hold_release' ||
      (k == 'hold' && (direction ?? '').trim() == 'credit')) {
    return 'hidden';
  }
  if (s == 'on_hold' || s == 'held') return 'held';
  if (s == 'hold_released' || s == 'rejected') return 'declined';
  if (k != 'transfer') return '';

  return (direction ?? '').trim() == 'credit' ? 'received' : 'sent';
}
