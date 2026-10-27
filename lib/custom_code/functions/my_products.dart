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

List<dynamic> myProducts(List<dynamic>? products) {
  // The catalogue also carries the products HAAT shares with every merchant; those
  // belong on the Cashier, not on the list of what this business has added.
  return (products ?? [])
      .where((p) => p is Map && p["isMine"] == true)
      .toList();
}
