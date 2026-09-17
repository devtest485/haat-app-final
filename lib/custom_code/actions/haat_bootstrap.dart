// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/backend/api/api_config.dart';
import '/backend/auth/auth_session.dart';

/// Brings the session up before the first frame.
///
/// This is the pair of lines `main.dart` used to run, and the reason the app
/// kept losing them: FlutterFlow regenerates `main.dart` on every export, so an
/// edit there survives exactly until the next one. Registered as a FlutterFlow
/// *initial action* instead, which is the supported hook for work that has to
/// finish before `runApp` — it is written into the generated `main.dart` by
/// FlutterFlow itself, so it cannot be exported away.
///
/// Order matters. The session restores tokens from the keystore, and it cannot
/// build its HTTP client until it knows where the backend is.
Future<void> haatBootstrap() async {
  await ApiConfig.load();
  await AuthSession.initialize();
}
