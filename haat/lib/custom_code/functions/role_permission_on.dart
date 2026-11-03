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

bool rolePermissionOn(
  List<dynamic>? roles,
  String? roleName,
  String? permissionKey,
) {
  for (final r in (roles ?? []).whereType<Map>()) {
    if ((r["name"] ?? "").toString() == roleName) {
      final permissions = r["permissions"];
      return permissions is List && permissions.contains(permissionKey);
    }
  }
  return false;
}
