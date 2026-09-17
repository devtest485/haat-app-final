import '/auth_flow/on_bording_flow/on_boardin_components/first/first_widget.dart';
import '/auth_flow/on_bording_flow/on_boardin_components/second/second_widget.dart';
import '/auth_flow/on_bording_flow/on_boardin_components/third/third_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'on_boarding_page_widget.dart' show OnBoardingPageWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class OnBoardingPageModel extends FlutterFlowModel<OnBoardingPageWidget> {
  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - haatStartupRoute] action in OnBoardingPage widget.
  String? startupRoute;
  // State field(s) for OnBoardingPageView widget.
  PageController? onBoardingPageViewController;

  int get onBoardingPageViewCurrentIndex =>
      onBoardingPageViewController != null &&
              onBoardingPageViewController!.hasClients &&
              onBoardingPageViewController!.page != null
          ? onBoardingPageViewController!.page!.round()
          : 0;
  // Model for First component.
  late FirstModel firstModel;
  // Model for Second component.
  late SecondModel secondModel;
  // Model for Third component.
  late ThirdModel thirdModel;

  @override
  void initState(BuildContext context) {
    firstModel = createModel(context, () => FirstModel());
    secondModel = createModel(context, () => SecondModel());
    thirdModel = createModel(context, () => ThirdModel());
  }

  @override
  void dispose() {
    firstModel.dispose();
    secondModel.dispose();
    thirdModel.dispose();
  }
}
