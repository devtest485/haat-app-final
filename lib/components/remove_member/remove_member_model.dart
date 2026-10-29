import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'remove_member_widget.dart' show RemoveMemberWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RemoveMemberModel extends FlutterFlowModel<RemoveMemberWidget> {
  ///  Local state fields for this component.

  bool? removing = false;

  String? error;

  List<String> revokeIds = [];
  void addToRevokeIds(String item) => revokeIds.add(item);
  void removeFromRevokeIds(String item) => revokeIds.remove(item);
  void removeAtIndexFromRevokeIds(int index) => revokeIds.removeAt(index);
  void insertAtIndexInRevokeIds(int index, String item) =>
      revokeIds.insert(index, item);
  void updateRevokeIdsAtIndex(int index, Function(String) updateFn) =>
      revokeIds[index] = updateFn(revokeIds[index]);

  int? loopIndex = 0;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - haatAccessToken] action in Container widget.
  String? token;
  // Stores action output result for [Backend Call - API (RevokeRole)] action in Container widget.
  ApiCallResponse? revokeResult;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
