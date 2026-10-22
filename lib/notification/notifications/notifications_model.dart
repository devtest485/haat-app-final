import '/backend/api_requests/api_calls.dart';
import '/components/notification_action_row/notification_action_row_widget.dart';
import '/components/notification_item/notification_item_widget.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'notifications_widget.dart' show NotificationsWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class NotificationsModel extends FlutterFlowModel<NotificationsWidget> {
  ///  Local state fields for this page.

  List<dynamic> pendingActions = [];
  void addToPendingActions(dynamic item) => pendingActions.add(item);
  void removeFromPendingActions(dynamic item) => pendingActions.remove(item);
  void removeAtIndexFromPendingActions(int index) =>
      pendingActions.removeAt(index);
  void insertAtIndexInPendingActions(int index, dynamic item) =>
      pendingActions.insert(index, item);
  void updatePendingActionsAtIndex(int index, Function(dynamic) updateFn) =>
      pendingActions[index] = updateFn(pendingActions[index]);

  List<dynamic> todayItems = [];
  void addToTodayItems(dynamic item) => todayItems.add(item);
  void removeFromTodayItems(dynamic item) => todayItems.remove(item);
  void removeAtIndexFromTodayItems(int index) => todayItems.removeAt(index);
  void insertAtIndexInTodayItems(int index, dynamic item) =>
      todayItems.insert(index, item);
  void updateTodayItemsAtIndex(int index, Function(dynamic) updateFn) =>
      todayItems[index] = updateFn(todayItems[index]);

  List<dynamic> earlierItems = [];
  void addToEarlierItems(dynamic item) => earlierItems.add(item);
  void removeFromEarlierItems(dynamic item) => earlierItems.remove(item);
  void removeAtIndexFromEarlierItems(int index) => earlierItems.removeAt(index);
  void insertAtIndexInEarlierItems(int index, dynamic item) =>
      earlierItems.insert(index, item);
  void updateEarlierItemsAtIndex(int index, Function(dynamic) updateFn) =>
      earlierItems[index] = updateFn(earlierItems[index]);

  bool loaded = false;

  bool failed = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - haatAccessToken] action in loadNotifications action block.
  String? token;
  // Stores action output result for [Backend Call - API (Notifications)] action in loadNotifications action block.
  ApiCallResponse? notificationsResult;
  // Stores action output result for [Backend Call - API (NotificationsSeen)] action in loadNotifications action block.
  ApiCallResponse? seenResult;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  /// Action blocks.
  Future loadNotifications(BuildContext context) async {
    token = await actions.haatAccessToken();
    notificationsResult = await HaatAuthGroup.notificationsCall.call(
      accessToken: token,
      language: FFAppState().languageCode,
    );

    if ((notificationsResult?.succeeded ?? true)) {
      pendingActions = (HaatAuthGroup.notificationsCall.actions(
                (notificationsResult?.jsonBody ?? ''),
              ) ??
              [])
          .toList()
          .cast<dynamic>();
      todayItems = (HaatAuthGroup.notificationsCall.today(
                (notificationsResult?.jsonBody ?? ''),
              ) ??
              [])
          .toList()
          .cast<dynamic>();
      earlierItems = (HaatAuthGroup.notificationsCall.earlier(
                (notificationsResult?.jsonBody ?? ''),
              ) ??
              [])
          .toList()
          .cast<dynamic>();
      failed = false;
      loaded = true;
      // The dots stay on this visit; the next one starts from now.
      seenResult = await HaatAuthGroup.notificationsSeenCall.call(
        accessToken: token,
      );
    } else {
      failed = true;
      loaded = true;
    }
  }
}
