// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/phone_format.dart';
import '/custom_code/auth_session.dart';

/// Signs in with whichever identifier was typed.
///
/// The field takes three kinds of thing and the backend refuses a request naming
/// more than one, so the app has to decide which was meant: an `@` makes it an
/// email, a leading `+` or all digits makes it a number, and anything else is a
/// handle.
///
/// An `MFA_REQUIRED` refusal comes back as a normal failure carrying `mfaToken` —
/// the screen has to collect a second code, and it needs that token to do it.
Future<String> haatSignIn(String identifier, String password) async {
  final session = AuthSession.instance;
  final typed = identifier.trim();
  final isNumber = _looksLikeNumber(typed);
  final isEmail = !isNumber && typed.contains('@');

  final result = await session.signIn(
    password: password,
    mobile: isNumber ? PhoneFormat.toE164(typed) : null,
    email: isEmail ? typed : null,
    username: (!isNumber && !isEmail) ? typed.toLowerCase() : null,
  );

  // Empty means it worked. Anything else is the message the server wrote, in
  // the language it was asked for, ready to show as-is.
  //
  // A String rather than the fuller JSON HaatResult builds, because a
  // FlutterFlow action chain cannot read a field out of a JSON return — there
  // is no JSON-path expression in the DSL — and an outcome a page cannot branch
  // on is not an outcome.
  return result.isSuccess ? '' : result.messageIn(session.languageCode);
}

bool _looksLikeNumber(String typed) => RegExp(r'^\+?[\d\s-]+$').hasMatch(typed);
