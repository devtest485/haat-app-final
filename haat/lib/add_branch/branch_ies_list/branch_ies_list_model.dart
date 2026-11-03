import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'branch_ies_list_widget.dart' show BranchIesListWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class BranchIesListModel extends FlutterFlowModel<BranchIesListWidget> {
  ///  Local state fields for this page.

  List<dynamic> branches = [];
  void addToBranches(dynamic item) => branches.add(item);
  void removeFromBranches(dynamic item) => branches.remove(item);
  void removeAtIndexFromBranches(int index) => branches.removeAt(index);
  void insertAtIndexInBranches(int index, dynamic item) =>
      branches.insert(index, item);
  void updateBranchesAtIndex(int index, Function(dynamic) updateFn) =>
      branches[index] = updateFn(branches[index]);

  bool branchesLoaded = false;

  String? loadError;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}

  /// Action blocks.
  Future loadBranches(BuildContext context) async {
    String? token;
    ApiCallResponse? branchesResult;

    token = await actions.haatAccessToken();
    branchesResult = await HaatAuthGroup.branchesCall.call(
      accessToken: token,
    );

    if ((branchesResult?.succeeded ?? true)) {
      branches = functions
          .activeBranches(HaatAuthGroup.branchesCall
              .branches(
                (branchesResult?.jsonBody ?? ''),
              )
              ?.toList())
          .toList()
          .cast<dynamic>();
      branchesLoaded = true;
      loadError = null;
      updatePage(() {});
    } else {
      loadError =
          'Your branches could not be loaded. Check your connection and pull to try again.';
      branchesLoaded = true;
      updatePage(() {});
    }
  }
}
