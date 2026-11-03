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

String transferVia(
  String? mode,
  dynamic recipient,
  String? value,
) {
  // How the person was found, as the sheet and Review Details show it: their @handle,
  // or their number as the server masked it.
  final data = recipient is Map ? recipient : const {};
  String text(dynamic v) => v == null || '$v' == 'null' ? '' : '$v'.trim();

  final username = text(data['username']);
  final masked = text(data['mobileMasked']);
  if (transferBy(mode) == 'username') {
    return '@${username.isNotEmpty ? username : text(value)}';
  }
  return masked.isNotEmpty ? masked : text(value);
}
