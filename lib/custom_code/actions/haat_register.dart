// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:uuid/uuid.dart';

import '/custom_code/haat_result.dart';
import '/custom_code/phone_format.dart';
import '/custom_code/auth_session.dart';

/// The number the current attempt belongs to, and the key standing for it.
///
/// Held across retries of the same number, so tapping Continue again on a bad
/// connection returns the first result rather than sending a second code.
/// Typing a different number is a different attempt and gets its own key.
///
/// Kept here rather than in page state because the FlutterFlow page would have
/// to carry two extra local fields and the branch that maintains them, and that
/// is bookkeeping the caller should not have to get right.
String? _attemptNumber;
String? _attemptKey;

String _idempotencyKeyFor(String mobile) {
  if (_attemptNumber != mobile) {
    _attemptNumber = mobile;
    _attemptKey = const Uuid().v4();
  }

  return _attemptKey!;
}

/// Starts registration for the typed number. Empty means it worked.
Future<String> haatRegister(String mobile) async {
  final session = AuthSession.instance;
  final e164 = PhoneFormat.toE164(mobile);

  return HaatResult.messageOrEmpty(
    await session.register(
      mobile: e164,
      idempotencyKey: _idempotencyKeyFor(e164),
    ),
    session.languageCode,
  );
}
