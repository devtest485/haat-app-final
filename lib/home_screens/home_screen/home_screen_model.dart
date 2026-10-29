import '/backend/api_requests/api_calls.dart';
import '/components/home_banner/home_banner_widget.dart';
import '/components/security_sheet_widget.dart';
import '/components/transactions/transactions_widget.dart';
import '/components/week_story_card/week_story_card_widget.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home_screens/business_story/business_story_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'home_screen_widget.dart' show HomeScreenWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreenModel extends FlutterFlowModel<HomeScreenWidget> {
  ///  Local state fields for this component.

  bool isBalanceVisible = true;

  bool switchd = false;

  List<dynamic> transactions = [];
  void addToTransactions(dynamic item) => transactions.add(item);
  void removeFromTransactions(dynamic item) => transactions.remove(item);
  void removeAtIndexFromTransactions(int index) => transactions.removeAt(index);
  void insertAtIndexInTransactions(int index, dynamic item) =>
      transactions.insert(index, item);
  void updateTransactionsAtIndex(int index, Function(dynamic) updateFn) =>
      transactions[index] = updateFn(transactions[index]);

  bool transactionsLoaded = false;

  List<dynamic> banners = [];
  void addToBanners(dynamic item) => banners.add(item);
  void removeFromBanners(dynamic item) => banners.remove(item);
  void removeAtIndexFromBanners(int index) => banners.removeAt(index);
  void insertAtIndexInBanners(int index, dynamic item) =>
      banners.insert(index, item);
  void updateBannersAtIndex(int index, Function(dynamic) updateFn) =>
      banners[index] = updateFn(banners[index]);

  int notificationsUnread = 0;

  List<dynamic> weekStories = [];
  void addToWeekStories(dynamic item) => weekStories.add(item);
  void removeFromWeekStories(dynamic item) => weekStories.remove(item);
  void removeAtIndexFromWeekStories(int index) => weekStories.removeAt(index);
  void insertAtIndexInWeekStories(int index, dynamic item) =>
      weekStories.insert(index, item);
  void updateWeekStoriesAtIndex(int index, Function(dynamic) updateFn) =>
      weekStories[index] = updateFn(weekStories[index]);

  int? bannerIndex = 0;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - haatAccessToken] action in HomeScreen widget.
  String? token;
  // Stores action output result for [Backend Call - API (Notifications)] action in HomeScreen widget.
  ApiCallResponse? apiResultid3;
  // Stores action output result for [Backend Call - API (MarketplaceBanners)] action in HomeScreen widget.
  ApiCallResponse? apiResultxlj;
  // Stores action output result for [Backend Call - API ( WeekStory)] action in HomeScreen widget.
  ApiCallResponse? apiResultatl;
  // Stores action output result for [Backend Call - API (RecentTransactions)] action in HomeScreen widget.
  ApiCallResponse? transactionsResult;
  // Stores action output result for [Backend Call - API (RecentTransactions)] action in HomeScreen widget.
  ApiCallResponse? apiResult1ib;
  // Stores action output result for [Custom Action - haatAccessToken] action in WalletBalance widget.
  String? balanceToken;
  // Stores action output result for [Backend Call - API (RecentTransactions)] action in WalletBalance widget.
  ApiCallResponse? balanceTransactions;
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
