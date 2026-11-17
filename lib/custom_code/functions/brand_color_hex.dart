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

String brandColorHex(dynamic item) {
  // The colour of a brand's store header, `#RRGGBB`. The back office picks it from its
  // palette (`brandColor`); a brand with none yet falls back to the colour of its launch
  // design, or grey for a brand the design never drew.
  final given = item is Map ? (item['brandColor'] ?? '').toString().trim() : '';
  if (RegExp(r'^#[0-9a-fA-F]{6}$').hasMatch(given)) return given.toUpperCase();

  final name = item is Map ? (item['name'] ?? '').toString() : '';
  switch (brandTone(name)) {
    case 'mtn':
      return '#FFC72C';
    case 'syber':
      return '#3E63FF';
    default:
      return '#8C8C8C';
  }
}
