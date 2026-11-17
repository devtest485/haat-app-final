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

String brandName(
  dynamic item,
  String? lang,
) {
  // The brand as the store screen and its card call it. The back office carries each brand
  // under whatever name it was typed with, so the three launch brands are named here.
  final given = (notificationText(item, 'name', lang ?? '') ?? '').trim();
  final key = given.toLowerCase();
  if (key.contains('mtn')) return 'MTN Sudan';
  if (key.contains('ikm')) return 'IKM Digital';
  if (key.contains('syber')) return 'Syberpay';
  return given;
}
