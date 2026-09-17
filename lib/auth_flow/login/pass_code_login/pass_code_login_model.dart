import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'pass_code_login_widget.dart' show PassCodeLoginWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PassCodeLoginModel extends FlutterFlowModel<PassCodeLoginWidget> {
  ///  Local state fields for this page.

  String? pinCode = '';

  bool isSubmitting = false;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  /// Action blocks.
  Future passcodeDigit(
    BuildContext context, {
    String? digit,
  }) async {
    String? pcKey;
    ApiCallResponse? pcResult;

    if (isSubmitting != false) {
      pinCode = functions.appendPinDigit(pinCode, digit!, 6);
      if (functions.isPinComplete(pinCode, 6) == true) {
        isSubmitting = true;
        pcKey = await actions.newUuid();
        pcResult = await HaatAuthGroup.signInWithPasscodeCall.call(
          passcode: pinCode,
          baseURL: FFAppState().accessToken,
          idempotencyKey: pcKey,
          authToken: FFAppState().languageCode,
        );

        isSubmitting = false;
        pinCode = '';
        if ((pcResult?.succeeded ?? true)) {
          context.pushNamed(BottomBarPagesWidget.routeName);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                getJsonField(
                  (pcResult?.jsonBody ?? ''),
                  r'''$.message''',
                ).toString(),
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
}
