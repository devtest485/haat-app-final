import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'setup_bisiness_location_page_widget.dart'
    show SetupBisinessLocationPageWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class SetupBisinessLocationPageModel
    extends FlutterFlowModel<SetupBisinessLocationPageWidget> {
  ///  Local state fields for this page.

  String? businessName;

  /// Why the name was refused — another business already has it — shown under
  /// the field until the merchant types a different one.
  String? nameError;

  ///  State fields for stateful widgets in this page.

  // State field(s) for BusinessNameField widget.
  FocusNode? businessNameFieldFocusNode;
  TextEditingController? businessNameFieldTextController;
  String? Function(BuildContext, String?)?
      businessNameFieldTextControllerValidator;
  // Stores action output result for [Custom Action - haatSaveBusinessSetup] action in Container widget.
  String? saved;
  // Stores action output result for [Custom Action - haatBusinessNameWasTaken] action in Container widget.
  bool? isTaken;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    businessNameFieldFocusNode?.dispose();
    businessNameFieldTextController?.dispose();
  }
}
