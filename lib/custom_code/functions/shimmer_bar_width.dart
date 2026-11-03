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

double shimmerBarWidth(
  int? index,
  int? bar,
) {
  // Width of one placeholder bar (0 title, 1 subtitle, 2 amount), varied by row so a
  // stack of them doesn't read as a grid.
  final i = index ?? 0;
  switch (bar) {
    case 0:
      return 120.0 + (i * 37 % 3) * 18.0;
    case 1:
      return 84.0 + (i % 2) * 14.0;
    default:
      return 76.0 + (i * 53 % 3) * 10.0;
  }
}
