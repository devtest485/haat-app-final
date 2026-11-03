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

String transferValue(
  String? mode,
  String? typed,
  String? dialCode,
) {
  // What the server looks the person up by: a lower-case handle without its @, or the
  // number in E.164 under the chosen country, a leading trunk zero dropped.
  final text = (typed ?? '').trim();
  if (transferBy(mode) == 'username') {
    return text.replaceFirst(RegExp(r'^@+'), '').toLowerCase();
  }

  var digits = text.replaceAll(RegExp(r'\D'), '');
  if (text.startsWith('+')) return digits.isEmpty ? '' : '+$digits';
  digits = digits.replaceFirst(RegExp(r'^0+'), '');
  if (digits.isEmpty) return '';

  final dial = (dialCode ?? '').replaceAll(RegExp(r'\D'), '');
  return '+$dial$digits';
}
