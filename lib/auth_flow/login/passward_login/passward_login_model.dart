import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'passward_login_widget.dart' show PasswardLoginWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class PasswardLoginModel extends FlutterFlowModel<PasswardLoginWidget> {
  ///  Local state fields for this page.

  bool setPassward = false;

  bool? isSubmitting = false;

  ///  State fields for stateful widgets in this page.

  // State field(s) for UsernameMobilenumber widget.
  FocusNode? usernameMobilenumberFocusNode;
  TextEditingController? usernameMobilenumberTextController;
  String? Function(BuildContext, String?)?
      usernameMobilenumberTextControllerValidator;
  // State field(s) for Password widget.
  FocusNode? passwordFocusNode;
  TextEditingController? passwordTextController;
  late bool passwordVisibility;
  String? Function(BuildContext, String?)? passwordTextControllerValidator;
  // Stores action output result for [Custom Action - haatSignIn] action in Container widget.
  String? signIn;

  @override
  void initState(BuildContext context) {
    passwordVisibility = false;
  }

  @override
  void dispose() {
    usernameMobilenumberFocusNode?.dispose();
    usernameMobilenumberTextController?.dispose();

    passwordFocusNode?.dispose();
    passwordTextController?.dispose();
  }
}
