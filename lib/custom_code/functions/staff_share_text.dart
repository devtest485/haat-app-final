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

String staffShareText(dynamic staff) {
  String field(String key) =>
      staff is Map ? (staff[key] ?? "").toString() : "";
  return "HAAT staff sign-in\n"
      "Name: ${field("fullName")}\n"
      "Role: ${field("roleName")} · ${field("branchName")}\n"
      "Username: ${field("username")}\n"
      "Temporary password: ${field("temporaryPassword")}\n"
      "They will set their own password the first time they sign in.";
}
