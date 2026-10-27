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

String staffSubtitle(dynamic member) {
  if (member is! Map) {
    return "";
  }
  final assignments =
      ((member["assignments"] as List?) ?? []).whereType<Map>().toList();
  final roles = assignments
      .map((a) => (a["roleName"] ?? "").toString().trim())
      .where((r) => r.isNotEmpty)
      .toSet()
      .join(", ");
  final branches = assignments
      .map((a) => (a["branchName"] ?? "").toString().trim())
      .where((b) => b.isNotEmpty)
      .toSet()
      .toList();
  final where = branches.isEmpty
      ? "All branches"
      : (branches.length == 1 ? branches.first : "${branches.length} branches");
  final status = (member["status"] ?? "active").toString();
  final parts = [
    if (roles.isNotEmpty) roles,
    where,
    if (status != "active") status[0].toUpperCase() + status.substring(1),
  ];
  return parts.join(" · ");
}
