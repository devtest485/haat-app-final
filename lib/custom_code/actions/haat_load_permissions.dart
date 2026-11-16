// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/auth_session.dart';

/// What the signed-in person's role lets them do, as `resource:action` keys.
///
/// Meant for App State `permissions`, which the `canDo` function reads to hide the
/// controls a role cannot use. An empty list means "unknown or no role" — a plain
/// personal account has none, and so does a failed read — and `canDo` treats it as
/// "show everything", so a slow network never locks a merchant out of their own screens.
/// The server checks every action again either way.
Future<List<String>> haatLoadPermissions() async {
  final result = await AuthSession.instance.access.mine();

  return result.valueOrNull ?? const <String>[];
}
