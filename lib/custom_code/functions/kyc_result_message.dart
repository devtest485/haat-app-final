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

String kycResultMessage(String result) {
  return switch (result) {
    'VERIFIED' => 'Your identity is verified.',
    'REVIEW' => 'Your documents are with our team for a closer look.',
    'REJECTED' => 'We could not verify those documents. You can try again.',
    _ => 'Your verification is still being processed.',
  };
}
