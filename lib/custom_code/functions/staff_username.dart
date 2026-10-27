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

String staffUsername(
  String? fullName,
  int attempt,
) {
  final words = (fullName ?? "")
      .toLowerCase()
      .split(RegExp(r"\s+"))
      .map((w) => w.replaceAll(RegExp(r"[^a-z0-9]"), ""))
      .where((w) => w.isNotEmpty)
      .take(2)
      .toList();
  var base = words.join(".");
  if (base.length > 24) {
    base = base.substring(0, 24);
  }
  base = base.replaceAll(RegExp(r"[._]+$"), "");
  if (base.isEmpty || !RegExp(r"^[a-z]").hasMatch(base)) {
    base = "staff$base";
  }
  if (base.length < 3 || base == "staff" || attempt > 0) {
    base = "$base${math.Random().nextInt(9000) + 1000}";
  }
  return base;
}
