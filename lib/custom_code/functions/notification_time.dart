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

String notificationTime(String? publishedAt) {
  final at = DateTime.tryParse(publishedAt ?? '')?.toLocal();
  if (at == null) return '';

  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final daysAgo = today.difference(DateTime(at.year, at.month, at.day)).inDays;

  if (daysAgo <= 0) return DateFormat('hh:mm a').format(at);
  if (daysAgo == 1) return 'Yesterday';
  return DateFormat(at.year == now.year ? 'd MMM' : 'd MMM y').format(at);
}
