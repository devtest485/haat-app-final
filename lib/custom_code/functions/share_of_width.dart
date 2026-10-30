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

double shareOfWidth(
  double total,
  double inset,
  double count,
  double gap,
) {
// The width of one of count tiles across total less inset, with gap between them.
  if (count <= 0) return 0;
  final width = (total - inset - gap * (count - 1)) / count;
  return width < 0 ? 0 : width;
}
