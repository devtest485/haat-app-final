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

String branchSubtitle(dynamic branch) {
  if (branch is! Map) {
    return "";
  }
  final address = (branch["address"] ?? "").toString().trim();
  final code = (branch["code"] ?? "").toString().trim();
  final detail = address.isNotEmpty ? address : (code.isNotEmpty ? "Code $code" : "");
  if (branch["isPrimary"] == true) {
    return detail.isEmpty ? "Main branch" : "Main branch · $detail";
  }
  return detail;
}
