import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'username_page_widget.dart' show UsernamePageWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UsernamePageModel extends FlutterFlowModel<UsernamePageWidget> {
  ///  Local state fields for this page.

  bool isValidUser = false;

  /// True while the handle is being checked or claimed.
  bool isChecking = false;
  bool isSubmitting = false;

  /// What the backend said about the handle last typed.
  ///
  /// Null until a check has come back. Kept so the field can say "already taken" or
  /// name the rule that was broken, rather than just refusing to enable the button.
  bool? isAvailable;
  String? unavailableReason;

  ///  State fields for stateful widgets in this page.

  // State field(s) for Username widget.
  FocusNode? usernameFocusNode;
  TextEditingController? usernameTextController;
  String? Function(BuildContext, String?)? usernameTextControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    usernameFocusNode?.dispose();
    usernameTextController?.dispose();
  }
}
