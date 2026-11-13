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

/// Lets the merchant choose the picture behind their profile header, and uploads it.
///
/// Empty means it worked or the merchant closed the picker; anything else is a
/// sentence to show. The profile reloads afterwards to pick up the new address.
Future<String> haatPickBusinessCover() async {
  final session = AuthSession.instance;

  // The header is drawn full-width, so it gets more pixels than a logo — but the
  // server takes 2 MB at most, and a straight camera photo is several times that.
  final picked = await ImagePicker().pickImage(
    source: ImageSource.gallery,
    maxWidth: 1440,
    maxHeight: 1440,
    imageQuality: 80,
  );

  if (picked == null) return '';

  final bytes = await picked.readAsBytes();

  final uploaded = await session.organizations.uploadCover(
    bytes: bytes,
    filename: picked.name.isEmpty ? 'cover.jpg' : picked.name,
  );

  if (uploaded is! ApiSuccess<String>) {
    return uploaded.messageIn(session.languageCode);
  }

  return '';
}
