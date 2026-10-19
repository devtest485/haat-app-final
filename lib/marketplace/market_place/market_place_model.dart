import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/marketplace/market_space/market_space_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'market_place_widget.dart' show MarketPlaceWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class MarketPlaceModel extends FlutterFlowModel<MarketPlaceWidget> {
  ///  Local state fields for this component.

  List<dynamic> banners = [];
  void addToBanners(dynamic item) => banners.add(item);
  void removeFromBanners(dynamic item) => banners.remove(item);
  void removeAtIndexFromBanners(int index) => banners.removeAt(index);
  void insertAtIndexInBanners(int index, dynamic item) =>
      banners.insert(index, item);
  void updateBannersAtIndex(int index, Function(dynamic) updateFn) =>
      banners[index] = updateFn(banners[index]);

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - haatAccessToken] action in MarketPlace widget.
  String? token;
  // Stores action output result for [Backend Call - API (MarketplaceBanners)] action in MarketPlace widget.
  ApiCallResponse? bannersResult;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
