import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import 'country_picker_widget.dart' show CountryPickerWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CountryPickerModel extends FlutterFlowModel<CountryPickerWidget> {
  ///  Local state fields for this component.

  List<dynamic> countries = [];
  void addToCountries(dynamic item) => countries.add(item);
  void removeFromCountries(dynamic item) => countries.remove(item);
  void removeAtIndexFromCountries(int index) => countries.removeAt(index);
  void insertAtIndexInCountries(int index, dynamic item) =>
      countries.insert(index, item);
  void updateCountriesAtIndex(int index, Function(dynamic) updateFn) =>
      countries[index] = updateFn(countries[index]);

  bool loaded = false;

  bool failed = false;

  ///  State fields for stateful widgets in this component.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }

  /// Action blocks.
  Future loadCountries(BuildContext context) async {
    String? token;
    ApiCallResponse? response;

    loaded = false;
    failed = false;
    updatePage(() {});
    token = await actions.haatAccessToken();
    response = await HaatAuthGroup.countriesCall.call(
      accessToken: token,
    );

    if ((response?.succeeded ?? true)) {
      countries = HaatAuthGroup.countriesCall
          .countries(
            (response?.jsonBody ?? ''),
          )!
          .toList()
          .cast<dynamic>();
      loaded = true;
      updatePage(() {});
    } else {
      failed = true;
      loaded = true;
      updatePage(() {});
    }
  }
}
