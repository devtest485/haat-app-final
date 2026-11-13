import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'change_password_sheet_widget.dart' show ChangePasswordSheetWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class ChangePasswordSheetModel
    extends FlutterFlowModel<ChangePasswordSheetWidget> {
  ///  Local state fields for this component.

  bool busy = false;

  String? errorMessage = '';

  ///  State fields for stateful widgets in this component.

  // State field(s) for CurrentPasswordField widget.
  FocusNode? currentPasswordFieldFocusNode;
  TextEditingController? currentPasswordFieldTextController;
  late bool currentPasswordFieldVisibility;
  String? Function(BuildContext, String?)?
      currentPasswordFieldTextControllerValidator;
  // State field(s) for NewPasswordField widget.
  FocusNode? newPasswordFieldFocusNode;
  TextEditingController? newPasswordFieldTextController;
  late bool newPasswordFieldVisibility;
  String? Function(BuildContext, String?)?
      newPasswordFieldTextControllerValidator;
  // State field(s) for ConfirmPasswordField widget.
  FocusNode? confirmPasswordFieldFocusNode;
  TextEditingController? confirmPasswordFieldTextController;
  late bool confirmPasswordFieldVisibility;
  String? Function(BuildContext, String?)?
      confirmPasswordFieldTextControllerValidator;
  // Stores action output result for [Custom Action - haatChangePassword] action in Container widget.
  String? changeResult;

  @override
  void initState(BuildContext context) {
    currentPasswordFieldVisibility = false;
    newPasswordFieldVisibility = false;
    confirmPasswordFieldVisibility = false;
  }

  @override
  void dispose() {
    currentPasswordFieldFocusNode?.dispose();
    currentPasswordFieldTextController?.dispose();

    newPasswordFieldFocusNode?.dispose();
    newPasswordFieldTextController?.dispose();

    confirmPasswordFieldFocusNode?.dispose();
    confirmPasswordFieldTextController?.dispose();
  }
}
