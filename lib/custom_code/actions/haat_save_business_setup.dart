// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import '/custom_code/api_result.dart';
import '/custom_code/auth_session.dart';

/// Registers the business and saves everything the setup screens collected.
///
/// This is where the three screens before it finally reach the backend. Until now
/// they wrote to App State and stopped there: a merchant picked where they sell,
/// picked what they sell, tapped Continue, and was shown a screen saying their
/// business had been created — while nothing had been sent anywhere.
///
/// ## Why it all happens here
///
/// `PATCH /organizations` needs a business to patch, and a business needs a name.
/// The name is asked for on this screen, so this is the first moment any of it can
/// be saved — the earlier answers wait in App State until there is somewhere to put
/// them.
///
/// Creating first and patching second, rather than one call, because that is the
/// shape the backend offers: `POST /organizations` makes the business and hands this
/// account ownership of it, and the profile fields are a separate write.
///
/// Empty means it worked. Anything else is a sentence to show.
Future<String> haatSaveBusinessSetup(String? businessName) async {
  final session = AuthSession.instance;
  final name = businessName?.trim() ?? '';

  if (name.isEmpty) {
    return 'Enter your business name to continue.';
  }

  // Already registered — a merchant who came back to this screen, or one whose
  // first attempt saved the business and then lost the network on the second call.
  // Making a second business for them would be worse than either.
  final existing = await session.organizations.currentOrganizationId();
  final alreadyHasOne =
      existing is ApiSuccess<String?> && (existing.value?.isNotEmpty ?? false);

  if (!alreadyHasOne) {
    final created = await session.createOrganization(name: name);

    if (created is! ApiSuccess<String>) {
      return created.messageIn(session.languageCode);
    }
  }

  final channels = FFAppState().selectedSalesChannels;

  final saved = await session.organizations.updateProfile(
    name: name,
    categories: List<String>.from(FFAppState().selectedCategories),
    // The backend stores one. The screen lets a merchant pick several — the design's
    // own second frame shows two ticked — so the first is sent and the rest are kept
    // in App State against the day the endpoint takes a list.
    salesChannel: channels.isEmpty ? null : channels.first,
  );

  if (saved is! ApiSuccess<bool>) {
    return saved.messageIn(session.languageCode);
  }

  return '';
}
