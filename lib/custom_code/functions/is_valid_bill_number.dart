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

/// Whether what was typed on "Pay your … bill" looks like a number for that bill.
///
/// A phone number is 9 to 12 digits, a meter 8 to 20; any other account needs at least
/// three characters. Spaces, dashes and a leading + are ignored.
bool isValidBillNumber(
  String? number,
  String? flow,
) {
  final typed = (number ?? '').trim();
  final digits = typed.replaceAll(RegExp(r'[\s\-+]'), '');
  final onlyDigits = RegExp(r'^\d+$').hasMatch(digits);

  switch ((flow ?? '').trim()) {
    case 'mobile':
      return onlyDigits && digits.length >= 9 && digits.length <= 12;
    case 'electricity':
      return onlyDigits && digits.length >= 8 && digits.length <= 20;
    default:
      return typed.length >= 3;
  }
}
