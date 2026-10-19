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

/// Reads who is signed in, and leaves it where the screens can bind to it.
///
/// Fills `displayName`, `mobileMasked` and `accountStatus` in App State from
/// `GET /auth/me`. The home screen's greeting was the literal string `AHMED ALAMIN`
/// until this existed — the design's placeholder, shipped and shown to everybody.
///
/// Returns nothing and says nothing on failure. A greeting is not worth an error in
/// front of somebody who has just signed in, and the fields keep whatever the last
/// successful read left them — which on a second visit is the right name anyway.
Future<void> haatLoadProfile() async {
  final session = AuthSession.instance;
  final profile = await session.refreshProfile();

  if (profile == null) return;

  // Written here rather than in AuthSession, which is ported Dart the tests run
  // without a widget tree — reaching for FFAppState there would drag FlutterFlow
  // into all of them.
  // The business's logo, if it has one. Asked separately because it belongs to the
  // business rather than the person — and a merchant who has not registered one yet
  // simply has none, which leaves the field empty and the screen on its placeholder.
  final logo = await session.organizations.currentLogoUrl();
  final logoUrl = logo is ApiSuccess<String?> ? (logo.value ?? '') : null;

  FFAppState().update(() {
    FFAppState().displayName = profile.displayName(session.username);
    FFAppState().mobileMasked = profile.mobileMasked;
    FFAppState().accountStatus = profile.status;
    // Only overwritten on a successful read, so a network blip does not blank a logo
    // the screen was already showing.
    if (logoUrl != null) FFAppState().businessLogoUrl = logoUrl;
  });
}
