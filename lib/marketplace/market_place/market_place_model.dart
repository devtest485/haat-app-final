import '/backend/api_requests/api_calls.dart';
import '/components/market_biller_tile/market_biller_tile_widget.dart';
import '/components/market_brand_card/market_brand_card_widget.dart';
import '/components/market_category_tile/market_category_tile_widget.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/marketplace/market_space/market_space_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
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

  List<dynamic> featured = [];
  void addToFeatured(dynamic item) => featured.add(item);
  void removeFromFeatured(dynamic item) => featured.remove(item);
  void removeAtIndexFromFeatured(int index) => featured.removeAt(index);
  void insertAtIndexInFeatured(int index, dynamic item) =>
      featured.insert(index, item);
  void updateFeaturedAtIndex(int index, Function(dynamic) updateFn) =>
      featured[index] = updateFn(featured[index]);

  List<dynamic> billers = [];
  void addToBillers(dynamic item) => billers.add(item);
  void removeFromBillers(dynamic item) => billers.remove(item);
  void removeAtIndexFromBillers(int index) => billers.removeAt(index);
  void insertAtIndexInBillers(int index, dynamic item) =>
      billers.insert(index, item);
  void updateBillersAtIndex(int index, Function(dynamic) updateFn) =>
      billers[index] = updateFn(billers[index]);

  List<dynamic> brands = [];
  void addToBrands(dynamic item) => brands.add(item);
  void removeFromBrands(dynamic item) => brands.remove(item);
  void removeAtIndexFromBrands(int index) => brands.removeAt(index);
  void insertAtIndexInBrands(int index, dynamic item) =>
      brands.insert(index, item);
  void updateBrandsAtIndex(int index, Function(dynamic) updateFn) =>
      brands[index] = updateFn(brands[index]);

  List<dynamic> categories = [];
  void addToCategories(dynamic item) => categories.add(item);
  void removeFromCategories(dynamic item) => categories.remove(item);
  void removeAtIndexFromCategories(int index) => categories.removeAt(index);
  void insertAtIndexInCategories(int index, dynamic item) =>
      categories.insert(index, item);
  void updateCategoriesAtIndex(int index, Function(dynamic) updateFn) =>
      categories[index] = updateFn(categories[index]);

  bool loaded = false;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - haatAccessToken] action in MarketPlace widget.
  String? token;
  // Stores action output result for [Backend Call - API (MarketplaceBanners)] action in MarketPlace widget.
  ApiCallResponse? bannersResult;
  // Stores action output result for [Backend Call - API (Marketplace)] action in MarketPlace widget.
  ApiCallResponse? marketplaceResult;
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
