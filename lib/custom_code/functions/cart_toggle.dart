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

/// The cart after a tap on a product card: in at one if it was not there, out if it was.
///
/// [product] is one row of `GET /products` as it came; the cart keeps only what the bar
/// and the Cart screen draw — `id`, `name`, `unit`, `priceMinor`, `imageUrl` and `qty` —
/// so it does not change shape if the API grows. [baseUrl] turns the relative
/// `imagePath` into an address, as `bannerImageUrl` does for a banner.
List<dynamic> cartToggle(
  List<dynamic>? cart,
  dynamic product,
  String? baseUrl,
) {
  final lines = List<dynamic>.from(cart ?? const []);
  final id = '${product is Map ? product['id'] ?? '' : ''}';
  if (id.isEmpty) return lines;

  final at = lines.indexWhere((line) => line is Map && '${line['id']}' == id);
  if (at != -1) {
    lines.removeAt(at);
    return lines;
  }

  final path = '${product['imagePath'] ?? ''}'.trim();
  final imageUrl = path.isEmpty || path == 'null'
      ? ''
      : path.startsWith('/')
          ? '${baseUrl ?? ''}$path'
          : path;

  lines.add(<String, dynamic>{
    'id': id,
    'name': '${product['name'] ?? ''}',
    'unit': '${product['unit'] ?? ''}',
    'priceMinor': '${product['priceMinor'] ?? '0'}',
    'imageUrl': imageUrl,
    'qty': 1,
  });

  return lines;
}
