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
import '/custom_code/auth_session.dart';
import '/custom_code/token_store.dart';

void _tell(BuildContext context, String message) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));
}

Future haatDeleteProduct(BuildContext context, String? productId) async {
  final id = productId?.trim() ?? '';
  if (id.isEmpty) {
    _tell(context, 'This product could not be found.');
    return;
  }
  await haatAccessToken();
  final tokens = TokenStore();
  await tokens.restore();
  final language = AuthSession.instance.languageCode;
  final client = ApiClient(tokens: tokens)..languageCode = language;
  try {
    final result = await client.delete('/products/$id', parse: (_) => true);
    if (!context.mounted) return;
    if (!result.isSuccess) {
      _tell(context, result.messageIn(language));
      return;
    }
    final navigator = Navigator.of(context);
    navigator.pop(true);
    if (navigator.canPop()) navigator.pop();
  } finally {
    client.close();
  }
}
