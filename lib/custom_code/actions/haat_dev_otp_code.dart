// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/backend/auth/auth_session.dart';

/// The one-time code, when a non-production backend chose to hand it back.
///
/// Empty against production, so everything downstream of it simply does not
/// happen there. This is not a bypass: the code is still sent to
/// `POST /auth/verify-otp` and still verified by the server, so the path walked
/// in development is the path that runs in production.
///
/// See `docs/BEFORE-GOING-LIVE.md`.
Future<String> haatDevOtpCode() async =>
    AuthSession.instance.devOtpCode ?? '';
