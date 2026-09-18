// Automatic FlutterFlow imports
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:blink_kyc/blink_kyc.dart';

/// The document the capture should ask for.
///
/// Named by the SDK's own enum so the value that crosses the action boundary and
/// the value the SDK takes are the same word. An unknown name falls back to the
/// national ID, which is what every capture used while the choice on
/// ChooseDocumentPage was wired to nothing.
DocumentType _documentType(String? name) => switch (name) {
      'passport' => DocumentType.passport,
      'idCard' => DocumentType.idCard,
      'drivingLicence' => DocumentType.drivingLicence,
      _ => DocumentType.nationalId,
    };

Future<String> runKycCapture(
  BuildContext context,
  String baseUrl,
  String sessionToken,
  String? documentType,
) async {
  try {
    await BlinkKyc(baseUrl, sessionToken)
        .document(type: _documentType(documentType))
        .face()
        .present(context)
        .run();

    return 'OK';
  } on BlinkStepError catch (error) {
    return error.message;
  } on BlinkError catch (error) {
    if (error.code == BlinkErrorCode.cancelled) return 'CANCELLED';

    return switch (error.code) {
      BlinkErrorCode.cameraDenied =>
        'HAAT needs camera access to check your ID. Allow it in your phone '
            'settings, then try again.',
      BlinkErrorCode.cameraUnavailable =>
        'The camera is not available. Close anything else using it, then try '
            'again.',
      BlinkErrorCode.network ||
      BlinkErrorCode.timeout =>
        'We could not reach the verification service. Check your connection '
            'and try again.',
      BlinkErrorCode.sessionExpired ||
      BlinkErrorCode.sessionSpent ||
      BlinkErrorCode.sessionInvalid =>
        'That attempt has expired. Tap Start Verification to begin a new one.',
      BlinkErrorCode.quotaExceeded =>
        'Verification is unavailable at the moment. Please try again later.',
      _ => 'The verification could not be completed. You can try again.',
    };
  } catch (_) {
    return 'The verification could not be completed. You can try again.';
  }
}
