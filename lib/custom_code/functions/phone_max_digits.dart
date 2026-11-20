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

int phoneMaxDigits(String? dialCode) {
  // How many characters a phone field takes under this country code: the most digits a
  // number there has, and one more for the leading zero people still type.
  const phoneLengths = {
    '249': [9, 9], // Sudan
    '211': [9, 9], // South Sudan
    '92': [10, 10], // Pakistan
    '966': [9, 9], // Saudi Arabia
    '971': [9, 9], // United Arab Emirates
    '20': [10, 10], // Egypt
    '974': [8, 8], // Qatar
    '965': [8, 8], // Kuwait
    '973': [8, 8], // Bahrain
    '968': [8, 8], // Oman
    '962': [9, 9], // Jordan
    '961': [7, 8], // Lebanon
    '964': [10, 10], // Iraq
    '963': [9, 9], // Syria
    '967': [9, 9], // Yemen
    '218': [9, 10], // Libya
    '216': [8, 8], // Tunisia
    '213': [9, 9], // Algeria
    '212': [9, 9], // Morocco
    '251': [9, 9], // Ethiopia
    '291': [7, 7], // Eritrea
    '253': [8, 8], // Djibouti
    '252': [7, 9], // Somalia
    '235': [8, 8], // Chad
    '91': [10, 10], // India
    '880': [10, 10], // Bangladesh
    '93': [9, 9], // Afghanistan
    '94': [9, 9], // Sri Lanka
    '977': [10, 10], // Nepal
    '90': [10, 10], // Türkiye
    '98': [10, 10], // Iran
    '44': [10, 10], // United Kingdom
    '1': [10, 10], // United States, Canada
    '7': [10, 10], // Russia, Kazakhstan
    '49': [10, 11], // Germany
    '33': [9, 9], // France
    '39': [9, 10], // Italy
    '34': [9, 9], // Spain
    '234': [10, 10], // Nigeria
    '254': [9, 9], // Kenya
    '256': [9, 9], // Uganda
    '255': [9, 9], // Tanzania
    '233': [9, 9], // Ghana
    '27': [9, 9], // South Africa
    '86': [11, 11], // China
    '62': [9, 12], // Indonesia
    '60': [9, 10], // Malaysia
    '65': [8, 8], // Singapore
    '63': [10, 10], // Philippines
    '66': [9, 9], // Thailand
    '84': [9, 10], // Vietnam
    '81': [10, 10], // Japan
    '82': [9, 10], // South Korea
    '61': [9, 9], // Australia
    '55': [10, 11], // Brazil
    '52': [10, 10], // Mexico
    '54': [10, 10], // Argentina
  };

  final dial = (dialCode ?? '').replaceAll(RegExp(r'\D'), '');
  final maxVal = (phoneLengths[dial] ?? [6, math.max(6, 15 - dial.length)])[1];

  return maxVal + 1;
}
