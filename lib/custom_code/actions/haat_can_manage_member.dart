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

/// Whether the signed-in user may change this member's role or remove them: never
/// the store's owner, and never themselves (they would lock themselves out).
Future<bool> haatCanManageMember(dynamic member) async {
  if (member is! Map || staffIsOwner(member)) return false;
  final me = AuthSession.instance.userId;
  return me == null || '${member['userId'] ?? ''}' != me;
}
