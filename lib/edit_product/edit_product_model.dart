import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

import 'dart:ui';

import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'edit_product_widget.dart' show EditProductWidget;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class EditProductModel extends FlutterFlowModel<EditProductWidget> {
  ///  Local state fields for this page.

  FFUploadedFile? photo;

  bool saving = false;

  String formError = '';

  bool outOfStock = false;

  bool? deleted;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Custom Action - haatPickProductPhoto] action in Container widget.
  FFUploadedFile? pickedPhoto;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode3;
  TextEditingController? textController3;
  String? Function(BuildContext, String?)? textController3Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode4;
  TextEditingController? textController4;
  String? Function(BuildContext, String?)? textController4Validator;
  // Stores action output result for [Custom Action - haatAccessToken] action in Container widget.
  String? token;
  // Stores action output result for [Backend Call - API (UpdateProduct)] action in Container widget.
  ApiCallResponse? updateResult;
  // Stores action output result for [Backend Call - API (UploadProductImage)] action in Container widget.
  ApiCallResponse? uploadResult;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();

    textFieldFocusNode3?.dispose();
    textController3?.dispose();

    textFieldFocusNode4?.dispose();
    textController4?.dispose();
  }
}
