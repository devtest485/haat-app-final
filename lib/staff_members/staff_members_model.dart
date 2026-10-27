import '/backend/api_requests/api_calls.dart';
import '/components/remove_member_widget.dart';
import '/components/role_access_widget.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'staff_members_widget.dart' show StaffMembersWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class StaffMembersModel extends FlutterFlowModel<StaffMembersWidget> {
  ///  Local state fields for this page.

  dynamic member;

  bool saving = false;

  List<String> revokeIds = [];
  void addToRevokeIds(String item) => revokeIds.add(item);
  void removeFromRevokeIds(String item) => revokeIds.remove(item);
  void removeAtIndexFromRevokeIds(int index) => revokeIds.removeAt(index);
  void insertAtIndexInRevokeIds(int index, String item) =>
      revokeIds.insert(index, item);
  void updateRevokeIdsAtIndex(int index, Function(String) updateFn) =>
      revokeIds[index] = updateFn(revokeIds[index]);

  int loopIndex = 0;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Bottom Sheet - RoleAccess] action in Row widget.
  dynamic newRole;
  // Stores action output result for [Custom Action - haatAccessToken] action in Row widget.
  String? token;
  // Stores action output result for [Backend Call - API (AssignRole)] action in Row widget.
  ApiCallResponse? assignResult;
  // Stores action output result for [Backend Call - API (RevokeRole)] action in Row widget.
  ApiCallResponse? revokeResult;
  // Stores action output result for [Backend Call - API (Staff)] action in Row widget.
  ApiCallResponse? staffResult;
  // Stores action output result for [Bottom Sheet - RemoveMember] action in Text widget.
  bool? removed;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
