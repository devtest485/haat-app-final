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

/// The number the one-time code was sent to, masked for display.
///
/// Read from the session rather than passed between screens as a route
/// parameter, so the OTP screen still knows it after the app has been
/// backgrounded and the route arguments have gone.
Future<String> haatPendingMobile() async {
  final mobile = AuthSession.instance.pendingMobile ?? '';
  if (mobile.length <= 8) return mobile;

  return '${mobile.substring(0, 4)} ⋯⋯ ${mobile.substring(mobile.length - 4)}';
}
