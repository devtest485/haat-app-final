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

dynamic transferBody(
  String? by,
  String? value,
  String? amountMinor,
  String? currency,
  String? transferReference,
  String? passcode,
  String? signature,
) {
  // The POST /transfers body, authorised by the passcode or, when there is one, by a
  // fingerprint signature over this same send.
  final signed = (signature ?? '').trim();
  return {
    'to': {'by': by ?? 'username', 'value': value ?? ''},
    'amountMinor': amountMinor ?? '',
    'currency': currency ?? 'SDG',
    'reference': transferReference ?? '',
    if (signed.isNotEmpty)
      'biometricSignature': signed
    else
      'passcode': passcode ?? '',
  };
}
