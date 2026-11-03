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

String outcomeText(
  dynamic outcome,
  String? field,
  String? fallback,
) {
  // A line of a send's outcome, or the design's own words when there is no outcome —
  // the status screens are opened by the demo flows as well, with nothing to show.
  final value = outcome is Map ? outcome[field ?? ''] : null;
  final text = value == null ? '' : '$value'.trim();
  return text.isEmpty || text == 'null' ? (fallback ?? '') : text;
}
