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

dynamic staffById(
  List<dynamic>? staff,
  String? userId,
) {
  for (final s in (staff ?? []).whereType<Map>()) {
    if ((s["userId"] ?? "").toString() == userId) {
      return s;
    }
  }
  return null;
}
