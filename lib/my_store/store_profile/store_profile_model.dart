import '/components/change_password_sheet/change_password_sheet_widget.dart';
import '/components/enable_biometrics_sheet/enable_biometrics_sheet_widget.dart';
import '/components/log_out/log_out_widget.dart';
import '/components/privacypolicy/privacypolicy_widget.dart';
import '/components/profile_photos_sheet/profile_photos_sheet_widget.dart';
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
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';

class StoreProfileModel extends FlutterFlowModel<StoreProfileWidget> {
  ///  Local state fields for this component.

  dynamic profile;

  bool? biometricKey = false;

  bool coverUploading = false;

  bool biometricSwitchValue = false;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - haatStoreProfile] action in StoreProfile widget.
  dynamic? profileResult;
  // Stores action output result for [Custom Action - haatHasBiometricKey] action in StoreProfile widget.
  bool? biometricKeyResult;
  // Stores action output result for [Bottom Sheet - ProfilePhotosSheet] action in Container widget.
  String? photoChoice;
  // Stores action output result for [Custom Action - haatPickBusinessCover] action in Container widget.
  String? coverResult;
  // Stores action output result for [Custom Action - haatStoreProfile] action in Container widget.
  dynamic? reloadResult;
  // Stores action output result for [Custom Action - haatPickBusinessLogo] action in Container widget.
  String? logoResult;
  // Stores action output result for [Custom Action - haatDisableBiometrics] action in Container widget.
  String? disableResult;
  // Stores action output result for [Bottom Sheet - EnableBiometricsSheet] action in Container widget.
  bool? biometricEnabled;
  // Stores action output result for [Custom Action - haatHasBiometricKey] action in Container widget.
  bool? biometricKeyRefresh;
  // Stores action output result for [Bottom Sheet - ChangePasswordSheet] action in Container widget.
  bool? passwordChanged;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
