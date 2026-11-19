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

String signupCountryField(
  dynamic country,
  String? field,
) {
  // One field of the country the sign-up number belongs to — iso, name, dialCode or flag —
  // or Pakistan's while none has been chosen, which is what the screen has always shown.
  const pakistan = {
    'iso': 'PK',
    'name': 'Pakistan',
    'dialCode': '92',
    'flag': '🇵🇰',
  };
  final key = (field ?? '').trim();
  final chosen = country is Map ? country[key] : null;
  final text = chosen == null ? '' : '$chosen'.trim();
  return text.isEmpty || text == 'null' ? (pakistan[key] ?? '') : text;
}
