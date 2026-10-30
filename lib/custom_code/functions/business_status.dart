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

String businessStatus(List<dynamic>? organizations) {
// The status of the business the user owns, else of the first one they belong to.
  final rows = (organizations ?? const []).whereType<Map>().toList();
  if (rows.isEmpty) return '';

  final owned = rows.where((row) => row['isOwner'] == true);
  final chosen = owned.isNotEmpty ? owned.first : rows.first;

  return '${chosen['status'] ?? ''}';
}
