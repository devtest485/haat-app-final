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

String countryField(
  dynamic country,
  String? field,
) {
  // One field of the chosen country — iso, name, dialCode or flag — or Sudan's, while
  // nothing has been chosen.
  const sudan = {
    'iso': 'SD',
    'name': 'Sudan',
    'dialCode': '249',
    'flag': '🇸🇩',
  };
  final key = (field ?? '').trim();
  final chosen = country is Map ? country[key] : null;
  final text = chosen == null ? '' : '$chosen'.trim();
  return text.isEmpty || text == 'null' ? (sudan[key] ?? '') : text;
}
