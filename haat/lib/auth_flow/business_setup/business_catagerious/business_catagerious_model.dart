import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
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

  // Stores action output result for [Custom Action - haatCategoriesChosen] action in Container widget.
  String? chosen;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
