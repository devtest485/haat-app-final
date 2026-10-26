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

List<dynamic> cartChangeQuantity(
  List<dynamic>? cart,
  String? productId,
  int? delta,
) {
  final lines = List<dynamic>.from(cart ?? const []);
  final at =
      lines.indexWhere((line) => line is Map && '${line['id']}' == productId);
  if (at == -1) return lines;

  final line = Map<String, dynamic>.from(lines[at] as Map);
  final qty = (int.tryParse('${line['qty']}') ?? 1) + (delta ?? 0);

  if (qty < 1) {
    lines.removeAt(at);
  } else {
    line['qty'] = qty > 999 ? 999 : qty;
    lines[at] = line;
  }

  return lines;
}
