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

String staffBranchName(dynamic member) {
  if (member is! Map) {
    return "All branches";
  }
  final branches = ((member["assignments"] as List?) ?? [])
      .whereType<Map>()
      .map((a) => (a["branchName"] ?? "").toString().trim())
      .where((b) => b.isNotEmpty)
      .toSet()
      .toList();
  if (branches.isEmpty) {
    return "All branches";
  }
  return branches.length == 1 ? branches.first : "${branches.length} branches";
}
