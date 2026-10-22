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

String newCustomFunction(String? minor) {
  final value = BigInt.tryParse((minor ?? '').trim()) ?? BigInt.zero;
  final hundred = BigInt.from(100);
  final major = (value ~/ hundred).toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+$)'),
        (match) => '${match[1]},',
      );
  final cents = (value % hundred).toInt();

  return cents == 0 ? major : '$major.${cents.toString().padLeft(2, '0')}';
}
