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

List<dynamic> staffRoles(List<dynamic>? roles) {
  return (roles ?? [])
      .where((r) =>
          r is Map &&
          r["scope"] != "platform" &&
          r["scope"] != "institution" &&
          r["key"] != "business_owner")
      .toList();
}
