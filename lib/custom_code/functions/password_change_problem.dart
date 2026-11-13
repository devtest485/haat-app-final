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

String passwordChangeProblem(
  String currentPassword,
  String newPassword,
  String confirmPassword,
) {
  // The first thing stopping the change, in words; empty when it can be sent.
  // Mirrors the server's rules so most mistakes never make the round trip.
  if (currentPassword.isEmpty) {
    return 'Enter your current password.';
  }
  if (newPassword.length < 8) {
    return 'Your new password needs at least 8 characters.';
  }
  final missing = <String>[
    if (!newPassword.contains(RegExp(r'[A-Z]'))) 'an uppercase letter',
    if (!newPassword.contains(RegExp(r'[a-z]'))) 'a lowercase letter',
    if (!newPassword.contains(RegExp(r'[0-9]'))) 'a number',
    if (!newPassword.contains(RegExp(r'[^A-Za-z0-9]'))) 'a symbol',
  ];
  if (missing.isNotEmpty) {
    final list = missing.length == 1
        ? missing.first
        : '${missing.sublist(0, missing.length - 1).join(', ')} and ${missing.last}';
    return 'Add $list to your new password.';
  }
  if (newPassword == currentPassword) {
    return 'Choose a password different from your current one.';
  }
  if (confirmPassword != newPassword) {
    return 'The new passwords do not match.';
  }
  return '';
}
