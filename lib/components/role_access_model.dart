import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import 'role_access_widget.dart' show RoleAccessWidget;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RoleAccessModel extends FlutterFlowModel<RoleAccessWidget> {
  ///  Local state fields for this component.

  List<dynamic> roles = [];
  void addToRoles(dynamic item) => roles.add(item);
  void removeFromRoles(dynamic item) => roles.remove(item);
  void removeAtIndexFromRoles(int index) => roles.removeAt(index);
  void insertAtIndexInRoles(int index, dynamic item) =>
      roles.insert(index, item);
  void updateRolesAtIndex(int index, Function(dynamic) updateFn) =>
      roles[index] = updateFn(roles[index]);

  dynamic selectedRole;

  String? loadError;

  bool loaded = false;

  ///  State fields for stateful widgets in this component.

  // Stores action output result for [Custom Action - haatAccessToken] action in RoleAccess widget.
  String? token;
  // Stores action output result for [Backend Call - API (Roles)] action in RoleAccess widget.
  ApiCallResponse? rolesResult;
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
}
