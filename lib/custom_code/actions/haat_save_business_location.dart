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

/// Saves where the business is: the point under the map pin and its address.
///
/// Empty means it worked. Anything else is a sentence to show. With no point yet
/// — the merchant never moved the map — it asks them to, rather than saving the
/// map's starting view as their address.
Future<String> haatSaveBusinessLocation(
    LatLng? location, String? address) async {
  if (location == null) {
    return 'Move the map so the pin sits on your business, then confirm.';
  }
  final session = AuthSession.instance;
  final line = address?.trim() ?? '';
  final saved = await session.organizations.updateProfile(
    latitude: location.latitude,
    longitude: location.longitude,
    addressLine: line.isEmpty ? null : line,
  );
  if (saved is! ApiSuccess<bool>) return saved.messageIn(session.languageCode);
  return '';
}
