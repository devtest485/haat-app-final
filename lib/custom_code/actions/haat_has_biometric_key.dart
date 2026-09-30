// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/auth_session.dart';

/// Whether this handset holds a device key, so the sign-in screen should offer
/// the fingerprint.
///
/// Asked of the phone every time rather than kept in App State: the key can be
/// destroyed without the app being told — a fingerprint is added, or the app's
/// data is cleared — and a remembered "yes" would offer an option that cannot work.
Future<bool> haatHasBiometricKey() => AuthSession.instance.hasBiometricKey();
