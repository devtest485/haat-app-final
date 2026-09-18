import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'like_bus_page_widget.dart' show LikeBusPageWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
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

  // Stores action output result for [Custom Action - haatSalesChannelChosen] action in Container widget.
  String? chosen;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
