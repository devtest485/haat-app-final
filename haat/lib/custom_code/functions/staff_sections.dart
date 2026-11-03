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

List<dynamic> staffSections(List<dynamic>? staff) {
  const managerKeys = ["branch_manager", "supervisor"];
  final managers = <dynamic>[];
  final cashiers = <dynamic>[];
  final others = <dynamic>[];

  for (final member in (staff ?? []).whereType<Map>()) {
    final keys = ((member["assignments"] as List?) ?? [])
        .whereType<Map>()
        .map((a) => (a["roleKey"] ?? "").toString())
        .toList();

    // The owner is the account itself, not somebody who works for it.
    if (keys.contains("business_owner")) {
      continue;
    }
    if (keys.any((k) => managerKeys.contains(k) || k.contains("manager"))) {
      managers.add(member);
    } else if (keys.contains("cashier")) {
      cashiers.add(member);
    } else {
      others.add(member);
    }
  }

  return [
    {"title": "MANAGERS · ${managers.length}", "members": managers},
    {"title": "CASHIERS · ${cashiers.length}", "members": cashiers},
    {"title": "OTHER STAFF · ${others.length}", "members": others},
  ].where((s) => (s["members"] as List).isNotEmpty).toList();
}
