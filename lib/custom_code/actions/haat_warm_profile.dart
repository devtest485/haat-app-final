// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

/// Starts reading who is signed in, when no name has been saved yet, and returns at
/// once: the sign-in prompts on the login screen don't wait for the network.
Future haatWarmProfile() async {
  if (FFAppState().displayName.isNotEmpty) return;
  haatLoadProfile().ignore();
}
