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

String roleSubtitle(dynamic role) {
  if (role is! Map) return "";
  final scope = (role["scope"] ?? "").toString().trim().toLowerCase();
  final reach = scope == "organization"
      ? "Whole business"
      : scope == "branch"
          ? "Their branch only"
          : scope == "own"
              ? "Their own work only"
              : "";
  final permissions = role["permissions"];
  final count = permissions is List ? permissions.length : 0;
  final access = count == 0
      ? ""
      : count == 1
          ? "1 permission"
          : "$count permissions";
  if (reach.isEmpty) return access;
  return access.isEmpty ? reach : "$reach · $access";
}
