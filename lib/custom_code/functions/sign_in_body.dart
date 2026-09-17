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

dynamic signInBody(
  String? identifier,
  String? password,
  String? deviceFingerprint,
  String? deviceLabel,
  String? platform,
) {
  final typed = (identifier ?? '').trim();

  final body = <String, dynamic>{
    'password': password ?? '',
    'deviceFingerprint': deviceFingerprint ?? '',
    'deviceLabel': deviceLabel ?? '',
    'platform': platform ?? '',
  };

  // Sirf ek pehchan bhejni hai. '+' ya sirf digits = number. '@' = email.
  // Baaqi sab handle hai.
  if (RegExp(r'^\+?[\d\s-]+$').hasMatch(typed)) {
    body['mobile'] = toE164(typed);
  } else if (typed.contains('@')) {
    body['email'] = typed;
  } else {
    body['username'] = typed.toLowerCase();
  }

  return body;
}
