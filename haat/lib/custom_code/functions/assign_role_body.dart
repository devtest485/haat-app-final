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

dynamic assignRoleBody(
  dynamic member,
  dynamic role,
) {
  final assignments = member is Map
      ? ((member["assignments"] as List?) ?? []).whereType<Map>().toList()
      : <Map>[];
  final branchId = assignments.isEmpty
      ? ""
      : (assignments.first["branchId"] ?? "").toString();
  return {
    "userId": member is Map ? (member["userId"] ?? "").toString() : "",
    "roleId": role is Map ? (role["id"] ?? "").toString() : "",
    if (branchId.isNotEmpty) "branchId": branchId,
  };
}
