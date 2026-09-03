import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'business_catagerious_widget.dart' show BusinessCatageriousWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BusinessCatageriousModel
    extends FlutterFlowModel<BusinessCatageriousWidget> {
  ///  Local state fields for this page.

  List<String> selectedCategories = [];
  void addToSelectedCategories(String item) => selectedCategories.add(item);
  void removeFromSelectedCategories(String item) =>
      selectedCategories.remove(item);
  void removeAtIndexFromSelectedCategories(int index) =>
      selectedCategories.removeAt(index);
  void insertAtIndexInSelectedCategories(int index, String item) =>
      selectedCategories.insert(index, item);
  void updateSelectedCategoriesAtIndex(int index, Function(String) updateFn) =>
      selectedCategories[index] = updateFn(selectedCategories[index]);

  bool blink = false;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - toggleSelection] action in Container widget.
  List<String>? click;
  // Stores action output result for [Custom Action - toggleSelection] action in Container widget.
  List<String>? click2;
  // Stores action output result for [Custom Action - toggleSelection] action in Container widget.
  List<String>? click3;
  // Stores action output result for [Custom Action - toggleSelection] action in Container widget.
  List<String>? click4;
  // Stores action output result for [Custom Action - toggleSelection] action in Container widget.
  List<String>? click5;
  // Stores action output result for [Custom Action - toggleSelection] action in Container widget.
  List<String>? click6;
  // Stores action output result for [Custom Action - toggleSelection] action in Container widget.
  List<String>? click7;
  // Stores action output result for [Custom Action - toggleSelection] action in Container widget.
  List<String>? click8;
  // Stores action output result for [Custom Action - toggleSelection] action in Container widget.
  List<String>? click9;
  // Stores action output result for [Custom Action - toggleSelection] action in Container widget.
  List<String>? click10;
  // Stores action output result for [Custom Action - toggleSelection] action in Container widget.
  List<String>? click11;
  // Stores action output result for [Custom Action - toggleSelection] action in Container widget.
  List<String>? click12;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
