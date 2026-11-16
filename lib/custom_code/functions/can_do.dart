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

bool canDo(
  List<String>? permissions,
  String? permission,
) {
// Whether the signed-in role may use a control. An empty list means the access was not
// read or the account has no role, so nothing is hidden; the server still enforces.
  if (permissions == null || permissions.isEmpty) return true;
  if (permission == null || permission.isEmpty) return true;

  return permissions.contains(permission);
}
