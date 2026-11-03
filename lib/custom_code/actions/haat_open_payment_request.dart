// Automatic FlutterFlow imports
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart'; // Imports other custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart' hide RepeatMode;
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

/// Closes the method sheet and opens the QR ([link] false) or payment link page for
/// [amount].
///
/// The router is taken before the sheet closes: once it has, the sheet's context is
/// gone.
Future haatOpenPaymentRequest(
  BuildContext context,
  String? amount,
  bool? link,
) async {
  final router = GoRouter.of(context);
  Navigator.of(context).pop();
  router.pushNamed(
    (link ?? false) ? 'LinkPayOutPage' : 'QRpayOutPage',
    queryParameters: {'amount': amount ?? ''},
  );
}
