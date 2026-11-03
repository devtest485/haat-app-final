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

/// Asks for a QR and NFC stand, delivered to the point the merchant chose on the
/// map and the address they confirmed.
///
/// Returns `{reference}` for the success screen, or `{error}` — a sentence to
/// show. The stand goes to the business's primary branch; the back office approves
/// or rejects the request, and the merchant hears which in their notifications.
Future<dynamic> haatRequestStand(
  LatLng? location,
  String? address,
  String? streetName,
  String? nearby,
) async {
  if (location == null) {
    return {
      'error':
          'Move the map so the pin sits where the stand should go, then continue.'
    };
  }
  final line = address?.trim() ?? '';
  if (line.length < 4) {
    return {'error': 'Enter the address the stand should be delivered to.'};
  }

  // Empty means not given; the backend caps each field, so a long map address is cut.
  String? field(String? value, int max) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return null;
    return text.length > max ? text.substring(0, max) : text;
  }

  final session = AuthSession.instance;
  final branch = await session.organizations.standBranchId();
  if (branch is! ApiSuccess<String?>) {
    return {'error': branch.messageIn(session.languageCode)};
  }
  final branchId = branch.valueOrNull;
  if (branchId == null) {
    return {
      'error': 'Add a branch to your business first, then request a stand.'
    };
  }

  final created = await session.organizations.requestStand(
    branchId: branchId,
    addressLine: field(line, 255)!,
    streetName: field(streetName, 160),
    nearby: field(nearby, 160),
    latitude: location.latitude,
    longitude: location.longitude,
  );
  if (created is! ApiSuccess<String>) {
    return {'error': created.messageIn(session.languageCode)};
  }
  return {'reference': created.valueOrNull ?? ''};
}
