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

String branchLocation(dynamic branch) {
  if (branch is! Map) {
    return "Not set";
  }
  final address = (branch["address"] ?? "").toString().trim();
  if (address.isNotEmpty) {
    // The first two parts of the address — the street and area — fit the row;
    // the whole of it would run off the screen.
    final parts = address
        .split(",")
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();
    final short = parts.take(2).join(", ");
    return short.length > 28 ? "${short.substring(0, 27)}…" : short;
  }
  final latitude = double.tryParse((branch["latitude"] ?? "").toString());
  final longitude = double.tryParse((branch["longitude"] ?? "").toString());
  if (latitude != null && longitude != null) {
    return "Pinned on map";
  }
  return "Not set";
}
