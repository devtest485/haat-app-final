import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/marketplace/market_space/market_space_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import 'market_place_widget.dart' show MarketPlaceWidget;
import 'package:carousel_slider/carousel_slider.dart';
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

  // Stores action output result for [Custom Action - haatMarketplaceBanners] action in MarketPlace widget.
  List<dynamic>? slides;
  // State field(s) for Carousel widget.
  CarouselSliderController? carouselController;
  int carouselCurrentIndex = 1;

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
