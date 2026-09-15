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

  /// True while the handle is being claimed.
  bool isSubmitting = false;

  /// What the server said about the handle as typed, or null before it has been asked.
  ///
  /// A handle is public identity and unique platform-wide, so "looks valid" and "is
  /// yours to take" are different questions and only the server can answer the second.
  bool? isAvailable;

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
