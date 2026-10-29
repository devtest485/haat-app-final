import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'empoley_role_widget.dart' show EmpoleyRoleWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EmpoleyRoleModel extends FlutterFlowModel<EmpoleyRoleWidget> {
  ///  Local state fields for this page.

  List<dynamic> branches = [];
  void addToBranches(dynamic item) => branches.add(item);
  void removeFromBranches(dynamic item) => branches.remove(item);
  void removeAtIndexFromBranches(int index) => branches.removeAt(index);
  void insertAtIndexInBranches(int index, dynamic item) =>
      branches.insert(index, item);
  void updateBranchesAtIndex(int index, Function(dynamic) updateFn) =>
      branches[index] = updateFn(branches[index]);

  List<dynamic> roles = [];
  void addToRoles(dynamic item) => roles.add(item);
  void removeFromRoles(dynamic item) => roles.remove(item);
  void removeAtIndexFromRoles(int index) => roles.removeAt(index);
  void insertAtIndexInRoles(int index, dynamic item) =>
      roles.insert(index, item);
  void updateRolesAtIndex(int index, Function(dynamic) updateFn) =>
      roles[index] = updateFn(roles[index]);

  String? roleId;

  String? roleName;

  String? branchId;

  String? branchName;

  bool loaded = false;

  String? loadError;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - haatAccessToken] action in EmpoleyRole widget.
  String? token;
  // Stores action output result for [Backend Call - API (Branches)] action in EmpoleyRole widget.
  ApiCallResponse? branchesResult;
  // Stores action output result for [Backend Call - API (Roles)] action in EmpoleyRole widget.
  ApiCallResponse? rolesResult;
  // Stores action output result for [Backend Call - API (Branches)] action in Row widget.
  ApiCallResponse? apiResult02f;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
