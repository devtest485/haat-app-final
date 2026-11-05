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

double channelBarWidth(
  double barWidth,
  List<double>? shares,
  int index,
) {
  // One part of the "How customers pay" bar: its share of the bar's width. With no
  // payments yet the last (gray) part fills the bar, so no channel looks used.
  final parts = shares ?? [];
  if (index < 0 || index >= parts.length || barWidth <= 0) {
    return 0;
  }
  final total = parts.fold<double>(0, (sum, s) => sum + (s < 0 ? 0 : s));
  if (total <= 0) {
    return index == parts.length - 1 ? barWidth : 0;
  }
  final share = parts[index] < 0 ? 0 : parts[index];
  return barWidth * share / total;
}
