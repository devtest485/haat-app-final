// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:image_picker/image_picker.dart';

import '/custom_code/api_result.dart';
import '/custom_code/auth_session.dart';

/// Lets the merchant choose their business logo, and uploads it.
///
/// The home screen showed a pizza shop's logo to every merchant — the design's
/// placeholder, bundled into the app. This is how a merchant replaces it with their
/// own. On success the address goes into `businessLogoUrl`, which the screens that
/// show the logo are bound to, so it appears everywhere at once.
///
/// ## Needs a business to exist
///
/// A logo belongs to a business, and the business is only registered when the name is
/// saved. So this is offered on the screen *after* naming — or, if a merchant reaches
/// it without one, it says so rather than uploading into nothing.
///
/// Empty means it worked or the merchant closed the picker; anything else is a
/// sentence to show.
Future<String> haatPickBusinessLogo() async {
  final session = AuthSession.instance;

  // Scaled down on the way out of the picker. A phone camera produces pictures many
  // times larger than a logo is ever drawn, and the server takes half a megabyte at
  // most — so a straight photo would be refused for a reason the merchant never saw.
  final picked = await ImagePicker().pickImage(
    source: ImageSource.gallery,
    maxWidth: 512,
    maxHeight: 512,
    imageQuality: 85,
  );

  if (picked == null) return '';

  final bytes = await picked.readAsBytes();

  final uploaded = await session.organizations.uploadLogo(
    bytes: bytes,
    filename: picked.name.isEmpty ? 'logo.jpg' : picked.name,
  );

  if (uploaded is! ApiSuccess<String>) {
    return uploaded.messageIn(session.languageCode);
  }

  FFAppState().update(() => FFAppState().businessLogoUrl = uploaded.value);

  return '';
}
