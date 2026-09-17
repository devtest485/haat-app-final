// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/auth_session.dart';

/// Where the app should send the user, as one word.
///
/// The decision is made here rather than as a chain of conditions on the page
/// for two reasons: it is five nested branches in the FlutterFlow editor and one
/// `switch` here, and the order of the checks is load-bearing — a user who must
/// change their password has to be sent to do that before anything notices they
/// also have no passcode yet.
///
/// Returns one of `login`, `createPassword`, `securePage`, `username`, `home`,
/// or `welcome` for a first run with no session at all.
Future<String> haatStartupRoute() async {
  final session = AuthSession.instance;

  if (!session.isSignedIn) {
    return FFAppState().hasLoggedInBefore ? 'login' : 'welcome';
  }

  final credentials = session.credentials;
  if (credentials == null) return 'home';

  // An employer chose this password and has read it. It is not a secret between
  // the account and its owner until the owner replaces it.
  if (credentials.mustChangePassword) return 'createPassword';
  if (!credentials.hasPassword) return 'createPassword';
  if (!credentials.hasPasscode) return 'securePage';

  final username = credentials.username;
  if (username == null || username.isEmpty) return 'username';

  return 'home';
}
