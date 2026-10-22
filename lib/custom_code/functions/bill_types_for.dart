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

/// The bill types a Marketplace bill is paid as, the chips on "Pay your … bill".
///
/// A phone bill is prepaid or postpaid, electricity is bought for a meter's phase, and
/// every other bill (`account`) has no type.
List<String> billTypesFor(String? flow) {
  switch ((flow ?? '').trim()) {
    case 'mobile':
      return ['Prepaid', 'Postpaid'];
    case 'electricity':
      return ['Single Phase', '3 Phase', 'Commercial'];
    default:
      return [];
  }
}
