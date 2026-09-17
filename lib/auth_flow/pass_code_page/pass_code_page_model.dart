import '/backend/auth/auth_session.dart';
import '/backend/ui/api_feedback.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'pass_code_page_widget.dart' show PassCodePageWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PassCodePageModel extends FlutterFlowModel<PassCodePageWidget> {
  ///  Local state fields for this page.

  String? pinCode;

  bool reenterPin = false;

  String? createdPasscode;

  int passcodeResult = 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  /// Action blocks.
  Future pinCodeHandler(
    BuildContext context, {
    String? digit,
    bool? reenterpin,
  }) async {
    passcodeResult = functions.passcodeStepResult(
        pinCode, createdPasscode, reenterpin!, digit!, 6);
    createdPasscode = functions.nextCreatedPasscode(
        pinCode, createdPasscode, reenterpin!, digit!, 6);
    reenterPin = functions.nextReenterPin(pinCode, reenterpin!, digit!, 6);
    pinCode = functions.nextPinCode(pinCode, digit!, 6);
    if (passcodeResult == 2) {
      // The passcode is set on the server, which stores only a hash of it. It is
      // deliberately not kept on the handset: signing in with it sends it to be
      // checked, so a copy here would be a secret held for no reason.
      final feedback = ApiFeedback.of(context);
      final result = await AuthSession.instance.setPasscode(createdPasscode!);

      if (!result.isSuccess) {
        feedback.show(result);

        // Back to the first entry, so the pair is retyped rather than half-kept.
        pinCode = null;
        createdPasscode = null;
        reenterPin = false;

        return;
      }

      if (context.mounted) {
        context.pushNamed(BiomatricPageWidget.routeName);
      }
    } else {
      if (passcodeResult == 3) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Passcode does not match. Please try again.',
              style: TextStyle(
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
            duration: Duration(milliseconds: 4000),
            backgroundColor: FlutterFlowTheme.of(context).secondary,
          ),
        );
      }
    }
  }
}
