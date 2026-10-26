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

List<dynamic>? notificationsFor(
  List<dynamic>? items,
  String? tab,
  String section,
) {
  final list = List<dynamic>.from(items ?? const []);
  final chosen = (tab ?? 'All').trim();

  if (chosen.isEmpty || chosen == 'All') return list;

  if (section == 'actions') {
    return chosen == 'Actions' ? list : [];
  }

  final category = switch (chosen) {
    'Offers' => 'offer',
    'Updates' => 'update',
    _ => null,
  };
  if (category == null) return [];

  return list
      .where((item) => item is Map && '${item['category']}' == category)
      .toList();
}
