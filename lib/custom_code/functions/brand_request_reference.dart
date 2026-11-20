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

String brandRequestReference() {
  // The reference shown on the "Request sent" screen: SW-<yymm>-<4 digits>.
  final now = DateTime.now();
  final yymm = DateFormat('yyMM').format(now);
  final digits =
      (now.millisecondsSinceEpoch % 10000).toString().padLeft(4, '0');
  return 'SW-$yymm-$digits';
}
