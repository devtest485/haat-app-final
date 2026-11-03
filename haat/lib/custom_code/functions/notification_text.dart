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

String? notificationText(
  dynamic item,
  String field,
  String? languageCode,
) {
  String read(String key) {
    if (item is! Map) return '';
    final value = item[key];
    if (value == null) return '';
    return value.toString().trim();
  }

  if ((languageCode ?? '').toLowerCase().startsWith('ar')) {
    final arabic = read('${field}Ar');
    if (arabic.isNotEmpty) return arabic;
  }

  return read(field);
}
