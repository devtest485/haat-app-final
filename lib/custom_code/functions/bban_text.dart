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

String bbanText(String? typed) {
  // What the BBAN field shows for what has been typed: nothing while there are no digits
  // — the hint shows instead — and from the first digit on, the country in front and the
  // number in the groups it is printed in: SD 090 123456789 01. Letters and spaces typed
  // or pasted are dropped; fourteen digits is all a number has.
  var digits = (typed ?? '').replaceAll(RegExp(r'\D'), '');
  if (digits.isEmpty) return '';
  if (digits.length > 14) digits = digits.substring(0, 14);

  final groups = [
    digits.substring(0, digits.length.clamp(0, 3)),
    if (digits.length > 3) digits.substring(3, digits.length.clamp(3, 12)),
    if (digits.length > 12) digits.substring(12),
  ];

  return 'SD ${groups.join(' ')}';
}
