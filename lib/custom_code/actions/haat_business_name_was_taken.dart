// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/actions/haat_save_business_setup.dart';

/// Whether the last [haatSaveBusinessSetup] was refused because another business
/// already uses that name — the one refusal only the merchant can fix, by typing a
/// different one. The business-setup screen puts it under the name field rather
/// than in a passing snackbar.
Future<bool> haatBusinessNameWasTaken() async => businessNameTakenOnLastSave();
