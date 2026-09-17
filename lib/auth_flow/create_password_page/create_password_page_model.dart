import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'create_password_page_widget.dart' show CreatePasswordPageWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreatePasswordPageModel
    extends FlutterFlowModel<CreatePasswordPageWidget> {
  ///  Local state fields for this page.

  bool isSame = true;

  bool isSubmitting = false;

  ///  State fields for stateful widgets in this page.

  // State field(s) for newPassward widget.
  FocusNode? newPasswardFocusNode;
  TextEditingController? newPasswardTextController;
  late bool newPasswardVisibility;
  String? Function(BuildContext, String?)? newPasswardTextControllerValidator;
  // State field(s) for ConfirmPassward widget.
  FocusNode? confirmPasswardFocusNode;
  TextEditingController? confirmPasswardTextController;
  late bool confirmPasswardVisibility;
  String? Function(BuildContext, String?)?
      confirmPasswardTextControllerValidator;
  // Stores action output result for [Custom Action - newUuid] action in Container widget.
  String? pwKey;
  // Stores action output result for [Backend Call - API (SetPassword)] action in Container widget.
  ApiCallResponse? setPwResult;
  // Stores action output result for [Backend Call - API (CredentialStatus)] action in Container widget.
  ApiCallResponse? credResult;

  @override
  void initState(BuildContext context) {
    newPasswardVisibility = false;
    confirmPasswardVisibility = false;
  }

  @override
  void dispose() {
    newPasswardFocusNode?.dispose();
    newPasswardTextController?.dispose();

    confirmPasswardFocusNode?.dispose();
    confirmPasswardTextController?.dispose();
  }
}
