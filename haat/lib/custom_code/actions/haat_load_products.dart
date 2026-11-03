// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/api_client.dart';
import '/custom_code/api_config.dart';
import '/custom_code/auth_session.dart';
import '/custom_code/token_store.dart';

/// The merchant's own products for the Products page, newest first.
Future<List<dynamic>> haatLoadProducts() async {
  await haatAccessToken();
  final tokens = TokenStore();
  await tokens.restore();
  final client = ApiClient(tokens: tokens)
    ..languageCode = AuthSession.instance.languageCode;
  try {
    final result =
        await client.get('/products', parse: (envelope) => envelope.list);
    return (result.valueOrNull ?? [])
        .whereType<Map<String, dynamic>>()
        .where((product) => product['isMine'] == true)
        .map((product) => <String, dynamic>{
              ...product,
              'priceLabel': moneyLabel(product['priceMinor']?.toString()),
              'imageUrl': _imageUrl(product['imagePath']),
              'priceText': minorToPriceText(product['priceMinor']?.toString()),
              'quantityText': quantityText(product['quantity']),
              'outOfStock': productOutOfStock(product),
            })
        .toList()
        .reversed
        .toList();
  } finally {
    client.close();
  }
}

String _imageUrl(dynamic path) {
  final clean = (path ?? '').toString().trim();
  if (clean.isEmpty) return '';
  return clean.startsWith('/') ? '${ApiConfig.baseUrl}$clean' : clean;
}
