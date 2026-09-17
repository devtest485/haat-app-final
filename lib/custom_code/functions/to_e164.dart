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

String toE164(String typed) {
  const dialCode = '+92';

  final trimmed = typed.trim();
  var digits = trimmed.replaceAll(RegExp(r'\D'), '');

  // Jisne khud '+' ke saath country code likha, uska wohi matlab tha. Uske aage
  // apna dial code aur laga dein to aisa number banta hai jo kisi ka bhi nahi —
  // Sudan ka +249 911 000 007 jaa kar +92249911000007 ban jata hai.
  if (trimmed.startsWith('+')) return '+$digits';

  // 92 se shuru ho raha hai to wo country code hi hai, dobara nahi lagana.
  if (digits.startsWith('92')) {
    digits = digits.substring(2);
  }

  // Log 0300... likhte hain. Country code ke saath wo zero nahi chahiye.
  while (digits.startsWith('0')) {
    digits = digits.substring(1);
  }

  return '$dialCode$digits';
}
