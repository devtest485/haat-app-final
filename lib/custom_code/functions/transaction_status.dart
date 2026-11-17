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

String transactionStatus(dynamic row) {
  // The status screen a statement line opens: Success, Pending or Error.
  if (row is! Map) return 'Success';
  final tone = transactionTone(
    '${row['kind'] ?? ''}',
    '${row['direction'] ?? ''}',
    '${row['status'] ?? ''}',
  );
  if (const ['pending', 'held'].contains(tone)) return 'Pending';
  if (const ['failed', 'declined', 'expired'].contains(tone)) return 'Error';
  return 'Success';
}
