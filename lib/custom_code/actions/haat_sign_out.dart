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

/// Ends the session and clears the keystore.
///
/// The business logo is left in App State, like `displayName`, so the login
/// screen can still greet the merchant with it. The next successful
/// `haatLoadProfile` overwrites it — with an empty value if that account has none.
Future<void> haatSignOut() async {
  await AuthSession.instance.signOut();
}
