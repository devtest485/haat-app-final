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

/// Whether the sign-in screen should offer "Login with Passcode".
///
/// True once this handset has been bound for passcode sign-in while signed in.
/// Without that binding the passcode cannot sign anybody in, so the option would
/// only ever produce a refusal.
Future<bool> haatHasPasscodeSignIn() async =>
    AuthSession.instance.hasPasscodeSignIn;
