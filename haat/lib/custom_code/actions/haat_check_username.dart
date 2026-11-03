// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/api_result.dart';
import '/custom_code/auth_session.dart';

/// Whether the handle is free. Empty means available.
///
/// Anything else is text to show under the field — the server's own wording for
/// why not, which covers "taken" and "not allowed" without the app having to
/// know the difference.
Future<String> haatCheckUsername(String username) async {
  final session = AuthSession.instance;
  final result = await session.api.checkUsername(username);

  return switch (result) {
    ApiSuccess(:final value) =>
      value.available ? '' : 'That username is already taken.',
    _ => result.messageIn(session.languageCode),
  };
}
