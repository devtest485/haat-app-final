import '/components/log_out/log_out_widget.dart';
import '/components/privacypolicy/privacypolicy_widget.dart';
import '/components/terms_of_uses/terms_of_uses_widget.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'store_profile_widget.dart' show StoreProfileWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class StoreProfileModel extends FlutterFlowModel<StoreProfileWidget> {
  ///  Local state fields for this component.

  dynamic profile;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - haatStoreProfile] action in StoreProfile widget.
  dynamic? profileResult;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
