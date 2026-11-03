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

List<dynamic> filterCountries(
  List<dynamic>? countries,
  String? query,
) {
  // The picker's list narrowed to what was typed: a name, an ISO code, or the start of
  // a dialling code, with or without its plus.
  final q = (query ?? '').trim().toLowerCase().replaceAll('+', '');
  final all = (countries ?? []).toList();
  if (q.isEmpty) return all;

  String field(dynamic c, String key) =>
      c is Map && c[key] != null ? '${c[key]}'.toLowerCase() : '';
  return all
      .where((c) =>
          field(c, 'name').contains(q) ||
          field(c, 'iso') == q ||
          field(c, 'dialCode').startsWith(q))
      .toList();
}
