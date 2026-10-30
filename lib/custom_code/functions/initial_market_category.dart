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

String initialMarketCategory(
  String? initialCategory,
  List<dynamic>? categories,
) {
// The tapped category, else For You when the back office has it, else every biller.
  final chosen = (initialCategory ?? '').trim();
  if (chosen.isNotEmpty) return chosen;

  final hasForYou = (categories ?? const [])
      .any((c) => c is Map && '${c['key']}' == 'for_you');
  return hasForYou ? 'for_you' : '';
}
