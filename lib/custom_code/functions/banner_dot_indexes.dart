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

/// `0, 1, … count - 1`: one entry per banner, for the dots under a card's headline.
///
/// Empty for a single banner — one dot points at nothing.
List<int> bannerDotIndexes(int? count) {
  final total = count ?? 0;
  return total < 2 ? <int>[] : List<int>.generate(total, (index) => index);
}
