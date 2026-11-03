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

List<dynamic> staffWithoutOwner(List<dynamic>? staff) {
  // The owner is the account itself, not somebody who works for it: the team
  // list, its count and its empty state are only the people they added.
  return (staff ?? [])
      .where((member) => !(member is Map &&
          ((member["assignments"] as List?) ?? [])
              .whereType<Map>()
              .any((a) => a["roleKey"] == "business_owner")))
      .toList();
}
