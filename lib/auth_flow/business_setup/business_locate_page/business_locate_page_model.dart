import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'business_locate_page_widget.dart' show BusinessLocatePageWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BusinessLocatePageModel
    extends FlutterFlowModel<BusinessLocatePageWidget> {
  ///  Local state fields for this page.

  LatLng? location;

  String? address;

  bool saving = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - haatSaveBusinessLocation] action in Container widget.
  String? saveError;
  // Stores action output result for [Custom Action - haatStartupRoute] action in Container widget.
  String? startupRoute;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
