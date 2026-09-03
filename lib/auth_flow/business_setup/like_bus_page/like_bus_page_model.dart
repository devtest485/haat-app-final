import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'like_bus_page_widget.dart' show LikeBusPageWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LikeBusPageModel extends FlutterFlowModel<LikeBusPageWidget> {
  ///  Local state fields for this page.

  List<String> isSelected = [];
  void addToIsSelected(String item) => isSelected.add(item);
  void removeFromIsSelected(String item) => isSelected.remove(item);
  void removeAtIndexFromIsSelected(int index) => isSelected.removeAt(index);
  void insertAtIndexInIsSelected(int index, String item) =>
      isSelected.insert(index, item);
  void updateIsSelectedAtIndex(int index, Function(String) updateFn) =>
      isSelected[index] = updateFn(isSelected[index]);

  bool select = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - toggleSelection] action in Container widget.
  List<String>? click1;
  // Stores action output result for [Custom Action - toggleSelection] action in Container widget.
  List<String>? click2;
  // Stores action output result for [Custom Action - toggleSelection] action in Container widget.
  List<String>? click3;
  // Stores action output result for [Custom Action - toggleSelection] action in Container widget.
  List<String>? click4;
  // Stores action output result for [Custom Action - toggleSelection] action in Container widget.
  List<String>? click5;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
