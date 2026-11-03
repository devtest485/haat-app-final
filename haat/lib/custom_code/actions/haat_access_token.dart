// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:convert';

import '/custom_code/auth_session.dart';
import '/custom_code/token_store.dart';

/// The signed-in session's access token for the HaatAuth API calls, renewed
/// first when it has run out.
///
/// Empty when signed out.
Future<String> haatAccessToken() async {
  final store = TokenStore();
  await store.restore();

  final token = store.accessToken ?? '';
  if (token.isEmpty || !_spent(token)) return token;

  await AuthSession.instance.refreshProfile();
  await store.restore();

  return store.accessToken ?? '';
}

bool _spent(String token) {
  try {
    final payload = token.split('.')[1];
    final claims = json
        .decode(utf8.decode(base64Url.decode(base64Url.normalize(payload))));
    final expires = claims['exp'];
    if (expires is! num) return false;

    final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    return now >= expires.toInt() - 30;
  } catch (_) {
    return false;
  }
}
