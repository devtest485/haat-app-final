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

String transferLookupError(
  String? mode,
  int? statusCode,
  String? errorCode,
  String? message,
) {
  // The line under the field when the person could not be found.
  if ((statusCode ?? 0) <= 0) {
    return 'Couldn’t reach HAAT. Check your connection and try again.';
  }
  if ((errorCode ?? '').trim() == 'NOT_FOUND') {
    return transferBy(mode) == 'username'
        ? 'This username doesn’t exist.'
        : 'No HAAT account uses this number.';
  }

  final given = (message ?? '').trim();
  return given.isEmpty || given == 'null'
      ? 'We couldn’t check this account. Try again.'
      : given;
}
