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

/// One of the dots under a banner's headline: the headline's colour for the card
/// on show, the same at a fifth of its strength for the others.
Color bannerDotColor(Color? background, int? dot, int? activeIndex) {
  final dark = (background ?? const Color(0xFF005A3B)).computeLuminance() > 0.4;
  final on = dark ? const Color(0xFF111111) : Colors.white;

  return dot == activeIndex ? on : on.withOpacity(0.2);
}
