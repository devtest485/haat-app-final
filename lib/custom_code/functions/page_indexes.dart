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

List<int> pageIndexes(
  int? count,
  int perPage,
) {
// One index per page of perPage items, and always at least one page.
  final total = count ?? 0;
  final pages =
      perPage < 1 ? 1 : ((total + perPage - 1) ~/ perPage).clamp(1, 99);
  return List<int>.generate(pages, (index) => index);
}
