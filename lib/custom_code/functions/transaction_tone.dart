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

/// How a statement line is coloured: `sent` (yellow) for money this business sent to
/// another merchant, `received` (green) for money another merchant sent it, and empty
/// for everything else, which keeps the statement's plain style.
String? transactionTone(
  String? kind,
  String? direction,
) {
  if ((kind ?? '').trim() != 'transfer') return '';

  return (direction ?? '').trim() == 'credit' ? 'received' : 'sent';
}
