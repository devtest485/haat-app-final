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

/// The colour of a banner's headline on its card: near-black on a light card,
/// white on the rest.
Color bannerOnColor(Color? background) {
  final dark = (background ?? const Color(0xFF005A3B)).computeLuminance() > 0.4;

  return dark ? const Color(0xFF111111) : Colors.white;
}
