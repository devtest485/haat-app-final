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

String maskPhoneNumber(String phoneNumber) {
  String cleaned = phoneNumber.replaceAll(' ', '');

  if (cleaned.isEmpty) return '';

  // Agar number bohat chota hai to mask na karein
  if (cleaned.length <= 8) return cleaned;

  // Shuru ke 4 characters (jaise +249)
  String startPart = cleaned.substring(0, 4);

  // Aakhri 4 digits
  String endPart = cleaned.substring(cleaned.length - 4);

  return '$startPart ⋯⋯ $endPart';
}
