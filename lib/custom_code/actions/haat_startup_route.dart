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
/// Returns one of `passcode`, `login`, `createPassword`, `securePage`,
/// `username`, `home`, or `welcome` for a first run with no session at all.
Future<String> haatStartupRoute() async {
  final session = AuthSession.instance;

  if (!session.isSignedIn) {
    return FFAppState().hasLoggedInBefore ? 'login' : 'welcome';
  }

  // Asked before anything else this run: the app is locked, and nothing behind
  // it is any of the caller's business until the passcode is given.
  if (session.lockedByPasscode) return 'passcode';

  final credentials = session.credentials;
  if (credentials == null) return 'home';

  // An employer chose this password and has read it. It is not a secret between
  // the account and its owner until the owner replaces it.
  if (credentials.mustChangePassword) return 'createPassword';
  if (!credentials.hasPassword) return 'createPassword';

  // A missing passcode is deliberately *not* a step to be sent back to.
  //
  // It used to be, and that is what put a merchant who had just named their
  // business back on the identity screen: naming it ends by asking this function
  // where to go, the answer was "set a passcode", and the passcode screen hands
  // on to biometrics, which hands on to verification, which hands on to business
  // setup — the whole of onboarding again, for somebody who had just finished it.
  //
  // The passcode is offered once, during onboarding, with "Not now" beside it. A
  // merchant who declines has an account that works; what they do not have is the
  // lock on re-opening the app, which is theirs to decline. It is offered again
  // from settings, not by refusing to let them past.

  final username = credentials.username;
  if (username == null || username.isEmpty) return 'username';

  return 'home';
}
