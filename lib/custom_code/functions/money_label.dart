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

/// An amount in minor units as the cards write it: `"300000"` is `3,000`, `"125050"`
/// is `1,250.50`. No currency — the card sets "SDG" beside it in its own size.
String moneyLabel(String? minor) {
  final value = BigInt.tryParse((minor ?? '').trim()) ?? BigInt.zero;
  final hundred = BigInt.from(100);
  final major = (value ~/ hundred).toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+$)'),
        (match) => '${match[1]},',
      );
  final cents = (value % hundred).toInt();

  return cents == 0 ? major : '$major.${cents.toString().padLeft(2, '0')}';
}
