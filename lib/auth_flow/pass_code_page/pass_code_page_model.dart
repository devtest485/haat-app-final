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
import '/backend/auth/auth_session.dart';
import '/backend/ui/api_feedback.dart';

class PassCodePageModel extends FlutterFlowModel<PassCodePageWidget> {
  ///  Local state fields for this page.

  String? pinCode;

  bool reenterPin = false;

  String? createdPasscode;

  int passcodeResult = 0;

  /// True while the confirmed passcode is being sent.
  bool isSubmitting = false;

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
      // Both entries matched. The passcode has to reach the backend before the flow
      // continues: a passcode that only exists on this handset would let somebody set
      // one, reinstall, and find it gone — with no way to tell why.
      if (isSubmitting) return;

      final feedback = ApiFeedback.of(context);
      isSubmitting = true;

      final result =
          await AuthSession.instance.setPasscode(createdPasscode ?? '');

      isSubmitting = false;

      if (!context.mounted) return;

      if (!result.isSuccess) {
        // Start the pair over. Leaving the confirmed value in place would show a
        // passcode as set when the server does not have it.
        pinCode = null;
        createdPasscode = null;
        reenterPin = false;
        feedback.show(result);
        return;
      }

      context.pushNamed(BiomatricPageWidget.routeName);
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
