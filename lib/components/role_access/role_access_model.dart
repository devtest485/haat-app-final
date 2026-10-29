import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'role_access_widget.dart' show RoleAccessWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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

  // Stores action output result for [Custom Action - haatLoadRoles] action in RoleAccess widget.
  List<dynamic>? loadedRoles;
  // State field(s) for ChoiceChips widget.
  FormFieldController<List<String>>? choiceChipsValueController;
  String? get choiceChipsValue =>
      choiceChipsValueController?.value?.firstOrNull;
  set choiceChipsValue(String? val) =>
      choiceChipsValueController?.value = val != null ? [val] : [];
  // State field(s) for Switch widget.
  bool? switchValue1;
  // State field(s) for Switch widget.
  bool? switchValue2;
  // State field(s) for Switch widget.
  bool? switchValue3;
  // State field(s) for Switch widget.
  bool? switchValue4;
  // State field(s) for Switch widget.
  bool? switchValue5;
  // State field(s) for Switch widget.
  bool? switchValue6;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
