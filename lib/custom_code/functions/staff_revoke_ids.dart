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

List<String> staffRevokeIds(
  dynamic member,
  dynamic role,
) {
  final assignments = member is Map
      ? ((member["assignments"] as List?) ?? []).whereType<Map>().toList()
      : <Map>[];
  if (assignments.isEmpty) {
    return [];
  }
  final branchId = assignments.first["branchId"];
  final roleId = role is Map ? role["id"] : null;
  return assignments
      .where((a) =>
          role == null || (a["branchId"] == branchId && a["roleId"] != roleId))
      .map((a) => (a["assignmentId"] ?? "").toString())
      .where((id) => id.isNotEmpty)
      .toList();
}
