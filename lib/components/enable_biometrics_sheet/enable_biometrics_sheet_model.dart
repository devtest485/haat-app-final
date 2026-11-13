import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'enable_biometrics_sheet_widget.dart' show EnableBiometricsSheetWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EnableBiometricsSheetModel
    extends FlutterFlowModel<EnableBiometricsSheetWidget> {
  ///  Local state fields for this component.

  bool busy = false;

  String? errorMessage = '';

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - haatEnableBiometrics] action in Container widget.
  String? enableResult;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
