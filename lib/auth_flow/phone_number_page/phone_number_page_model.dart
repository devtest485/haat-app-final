import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'phone_number_page_widget.dart' show PhoneNumberPageWidget;
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class PhoneNumberPageModel extends FlutterFlowModel<PhoneNumberPageWidget> {
  ///  Local state fields for this page.

  bool isPhoneValid = false;

  /// True while registration is in flight, so a second tap cannot start a second one.
  bool isSubmitting = false;

  String? _attemptKey;
  String? _attemptNumber;

  /// The idempotency key for registering [mobile].
  ///
  /// Held across retries of the same number, so tapping Continue again on a bad
  /// connection returns the first result rather than sending a second code. Typing a
  /// different number is a different attempt and gets its own key.
  String idempotencyKeyFor(String mobile) {
    if (_attemptNumber != mobile) {
      _attemptNumber = mobile;
      _attemptKey = const Uuid().v4();
    }

    return _attemptKey!;
  }

  ///  State fields for stateful widgets in this page.

  final formKey = GlobalKey<FormState>();
  // State field(s) for phone widget.
  FocusNode? phoneFocusNode;
  TextEditingController? phoneTextController;
  String? Function(BuildContext, String?)? phoneTextControllerValidator;
  String? _phoneTextControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Enter your phone is required';
    }

    if (!RegExp('^[0-9]+\$').hasMatch(val)) {
      return 'Invalid text';
    }
    return null;
  }

  // Stores action output result for [Validate Form] action in Container widget.
  bool? valid;

  @override
  void initState(BuildContext context) {
    phoneTextControllerValidator = _phoneTextControllerValidator;
  }

  @override
  void dispose() {
    phoneFocusNode?.dispose();
    phoneTextController?.dispose();
  }
}
