import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'transfer_auth_widget.dart' show TransferAuthWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class TransferAuthModel extends FlutterFlowModel<TransferAuthWidget> {
  ///  Local state fields for this component.

  String error = '';

  bool busy = false;

  bool fingerprint = false;

  String passcode = '';

  String signature = '';

  dynamic outcome;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - haatFingerprintAvailable] action in TransferAuth widget.
  bool? available;
  // State field(s) for TextField widget.
  late FocusNode textFieldPasswordVisibilityFocusNode;
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? textControllerValidator;
  // Stores action output result for [Custom Action - haatTransferFingerprint] action in Container widget.
  dynamic? approval;

  @override
  void initState(BuildContext context) {
    textFieldPasswordVisibilityFocusNode = FocusNode();
    passwordVisibility = false;
  }

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
    textFieldPasswordVisibilityFocusNode.dispose();
  }

  /// Action blocks.
  Future sendTransfer(BuildContext context) async {
    String? token;
    ApiCallResponse? response;

    token = await actions.haatAccessToken();
    response = await HaatAuthGroup.sendTransferCall.call(
      accessToken: token,
      bodyJson: functions.transferBody(
          widget!.by,
          widget!.value,
          widget!.amountMinor,
          widget!.currency,
          widget!.transferReference,
          passcode,
          signature),
      idempotencyKey: widget!.transferReference,
    );

    outcome = functions.transferOutcome(
        (response?.statusCode ?? 200),
        (response?.jsonBody ?? ''),
        widget!.amountMinor,
        widget!.currency,
        widget!.transferReference,
        widget!.via);
    updatePage(() {});
    if (functions.outcomeText(outcome, 'kind', '') == 'credential') {
      error = functions.outcomeText(
          outcome, 'message', 'That passcode isn’t right.');
      busy = false;
      signature = '';
      passcode = '';
      updatePage(() {});
    } else {
      FFAppState().lastTransfer = outcome!;
      Navigator.pop(context);
    }
  }
}
