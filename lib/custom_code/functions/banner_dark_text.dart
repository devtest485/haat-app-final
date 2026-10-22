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

/// Whether a banner's logo, headline and dots are drawn dark on its colour.
///
/// True on a light card — the palette's Sun (`#FFC800`) — and false on Forest, Blue,
/// Ink and Red, which take white. The admin preview makes the same choice.
bool bannerDarkText(Color? background) {
  return (background ?? const Color(0xFF005A3B)).computeLuminance() > 0.4;
}
