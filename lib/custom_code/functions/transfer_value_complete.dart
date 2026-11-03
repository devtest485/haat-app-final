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

bool transferValueComplete(
  String? mode,
  String? typed,
  String? dialCode,
) {
  // Worth asking the server about: a handle of the shape usernames take, or a number
  // with a length a real one could have (E.164 allows fifteen digits in all, and no
  // country's numbers are shorter than six).
  if (transferBy(mode) == 'username') {
    return RegExp(r'^[a-z0-9._]{3,30}$')
        .hasMatch(transferValue(mode, typed, dialCode));
  }

  final text = (typed ?? '').trim();
  final national =
      text.replaceAll(RegExp(r'\D'), '').replaceFirst(RegExp(r'^0+'), '');
  if (text.startsWith('+'))
    return national.length >= 8 && national.length <= 15;

  final dial = (dialCode ?? '').replaceAll(RegExp(r'\D'), '');
  return national.length >= 6 && national.length + dial.length <= 15;
}
