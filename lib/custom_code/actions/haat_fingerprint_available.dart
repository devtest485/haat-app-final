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

/// Whether this phone can approve a transfer with its fingerprint.
///
/// Only the hardware and an enrolled finger count: a phone without a key yet is set up
/// on the spot when the fingerprint is used.
Future<bool> haatFingerprintAvailable() async =>
    await AuthSession.instance.biometrics.availability() == null;
