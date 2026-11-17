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

String brandTone(String? name) {
  // Which header a brand store wears: mtn (yellow), ikm (grey), syber (blue), else neutral.
  final key = (name ?? '').toLowerCase();
  if (key.contains('mtn')) return 'mtn';
  if (key.contains('ikm')) return 'ikm';
  if (key.contains('syber')) return 'syber';
  return 'neutral';
}
