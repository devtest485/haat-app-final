import '/backend/api_requests/api_calls.dart';
import '/components/staff_shimmer/staff_shimmer_widget.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'staff_widget.dart' show StaffWidget;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class StaffModel extends FlutterFlowModel<StaffWidget> {
  ///  Local state fields for this page.

  List<dynamic> staff = [];
  void addToStaff(dynamic item) => staff.add(item);
  void removeFromStaff(dynamic item) => staff.remove(item);
  void removeAtIndexFromStaff(int index) => staff.removeAt(index);
  void insertAtIndexInStaff(int index, dynamic item) =>
      staff.insert(index, item);
  void updateStaffAtIndex(int index, Function(dynamic) updateFn) =>
      staff[index] = updateFn(staff[index]);

  bool? staffLoaded = false;

  String? loadError;

  ///  State fields for stateful widgets in this page.

  // Model for StaffShimmer component.
  late StaffShimmerModel staffShimmerModel;

  @override
  void initState(BuildContext context) {
    staffShimmerModel = createModel(context, () => StaffShimmerModel());
  }

  @override
  void dispose() {
    staffShimmerModel.dispose();
  }

  /// Action blocks.
  Future loadStaff(BuildContext context) async {
    String? token;
    ApiCallResponse? staffResult;

    token = await actions.haatAccessToken();
    staffResult = await HaatAuthGroup.staffCall.call(
      accessToken: token,
    );

    if ((staffResult?.succeeded ?? true)) {
      staff = functions
          .staffWithoutOwner(HaatAuthGroup.staffCall
              .staff(
                (staffResult?.jsonBody ?? ''),
              )
              ?.toList())
          .toList()
          .cast<dynamic>();
      loadError = null;
      staffLoaded = true;
      updatePage(() {});
    } else {
      loadError =
          'Your team could not be loaded. Check your connection and pull to try again.';
      staffLoaded = true;
      updatePage(() {});
    }
  }
}
