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

bool signupPhoneComplete(
  String? typed,
  dynamic country,
) {
  // Whether the number typed is whole under the country chosen: ten digits for Pakistan,
  // which has always been the rule, and any number a country could have for the others
  // (E.164 allows fifteen digits in all, counting the country code).
  final dial = signupCountryField(country, 'dialCode').replaceAll(RegExp(r'\D'), '');
  final national = (typed ?? '')
      .replaceAll(RegExp(r'\D'), '')
      .replaceFirst(RegExp(r'^0+'), '');
  if (dial == '92') return national.length == 10;
  return national.length >= 6 && national.length + dial.length <= 15;
}
