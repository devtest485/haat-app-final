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

List<dynamic>? marketplaceItemsFor(
  List<dynamic>? items,
  String? category,
  String? query,
) {
  final chosen = (category ?? '').trim();
  final needle = (query ?? '').trim().toLowerCase();

  return (items ?? []).where((item) {
    if (item is! Map) return false;

    if (chosen == 'for_you') {
      if (item['isFeatured'] != true) return false;
    } else if (chosen.isNotEmpty && item['category'] != chosen) {
      return false;
    }

    if (needle.isEmpty) return true;
    final name = '${item['name'] ?? ''} ${item['nameAr'] ?? ''}'.toLowerCase();
    return name.contains(needle);
  }).toList();
}
