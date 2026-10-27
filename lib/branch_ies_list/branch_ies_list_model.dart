import '/backend/api_requests/api_calls.dart';
import '/components/empty_state/empty_state_widget.dart';
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

  String loadError = '';

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - haatAccessToken] action in BranchIesList widget.
  String? token;
  // Stores action output result for [Backend Call - API (Branches)] action in BranchIesList widget.
  ApiCallResponse? branchesResult;
  // Model for EmptyState component.
  late EmptyStateModel emptyStateModel;

  @override
  void initState(BuildContext context) {
    emptyStateModel = createModel(context, () => EmptyStateModel());
  }

  @override
  void dispose() {
    emptyStateModel.dispose();
  }

  /// Action blocks.
  Future loadBranches(BuildContext context) async {
    token = await actions.haatAccessToken();
    branchesResult = await HaatAuthGroup.branchesCall.call(
      accessToken: token,
    );

    if ((branchesResult?.succeeded ?? true)) {
      // Branches are opened and closed from the HAAT dashboard; a closed one stays
      // in the books but no longer belongs on this list.
      branches = functions
          .activeBranches(HaatAuthGroup.branchesCall
              .branches((branchesResult?.jsonBody ?? ''))
              ?.toList())
          .toList()
          .cast<dynamic>();
      loadError = '';
      branchesLoaded = true;
    } else {
      loadError =
          'Your branches could not be loaded. Check your connection and pull to try again.';
      branchesLoaded = true;
    }
  }
}
