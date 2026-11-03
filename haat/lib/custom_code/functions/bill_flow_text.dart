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

String billFlowText(
  String? flow,
  String? name,
  String field,
) {
  final biller = (name ?? '').trim();

  switch ((flow ?? '').trim()) {
    case 'mobile':
      switch (field) {
        case 'subtitle':
          return 'Select bill type and enter the $biller number to pay.';
        case 'label':
          return '$biller mobile number';
        case 'hint':
          return 'Enter the mobile number';
        case 'error':
          return 'Enter a valid $biller mobile number.';
        case 'amountTitle':
          return 'Enter the top-up amount';
        case 'numberLabel':
          return 'Mobile number';
      }
      break;
    case 'electricity':
      switch (field) {
        case 'subtitle':
          return 'Select the meter type and enter the meter number.';
        case 'label':
          return 'Meter number';
        case 'hint':
          return 'Enter the meter number';
        case 'error':
          return 'Enter a valid meter number.';
        case 'amountTitle':
          return 'Enter the amount';
        case 'numberLabel':
          return 'Meter number';
      }
      break;
  }

  switch (field) {
    case 'subtitle':
      return 'Enter your $biller account number to pay.';
    case 'label':
      return 'Account number';
    case 'hint':
      return 'Enter the account number';
    case 'error':
      return 'Enter a valid account number.';
    case 'amountTitle':
      return 'Enter the amount';
    case 'numberLabel':
      return 'Account number';
  }
  return '';
}
