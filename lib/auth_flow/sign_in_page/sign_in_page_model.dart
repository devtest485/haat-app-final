import '/flutter_flow/flutter_flow_model.dart';
import 'package:flutter/material.dart';

import 'sign_in_page_widget.dart' show SignInPageWidget;

/// Which identifier the person is signing in with.
///
/// The backend accepts a mobile number, a username or an email, and refuses more than
/// one — so the screen has to pick, and the two cases are genuinely different people. A
/// merchant registered with a phone number. An employee whose account their employer
/// created has no phone number on file at all, only the handle they were handed.
enum SignInIdentifier { mobile, handle }

class SignInPageModel extends FlutterFlowModel<SignInPageWidget> {
  final formKey = GlobalKey<FormState>();

  SignInIdentifier identifier = SignInIdentifier.mobile;

  FocusNode? identifierFocusNode;
  TextEditingController? identifierTextController;

  FocusNode? passwordFocusNode;
  TextEditingController? passwordTextController;
  bool passwordVisible = false;

  bool isSubmitting = false;

  /// Set when the password was accepted and a second factor is still owed.
  ///
  /// Its presence is what turns the screen into a code prompt, so the user is not sent
  /// to another route mid-sign-in and left unable to go back.
  String? mfaToken;
  FocusNode? codeFocusNode;
  TextEditingController? codeTextController;

  /// Seconds remaining on a lockout, counted down from what the server reported.
  int lockedForSeconds = 0;

  bool get isLocked => lockedForSeconds > 0;

  /// Whether there is enough typed in to be worth sending.
  bool get canSubmit =>
      !isSubmitting &&
      !isLocked &&
      (identifierTextController?.text.trim().isNotEmpty ?? false) &&
      (passwordTextController?.text.isNotEmpty ?? false);

  String get identifierLabel => switch (identifier) {
        SignInIdentifier.mobile => 'Phone number',
        SignInIdentifier.handle => 'Username or email',
      };

  String get identifierHint => switch (identifier) {
        SignInIdentifier.mobile => '3001234567',
        SignInIdentifier.handle => 'yourname',
      };

  TextInputType get identifierKeyboard => switch (identifier) {
        SignInIdentifier.mobile => TextInputType.phone,
        SignInIdentifier.handle => TextInputType.emailAddress,
      };

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    identifierFocusNode?.dispose();
    identifierTextController?.dispose();

    passwordFocusNode?.dispose();
    passwordTextController?.dispose();

    codeFocusNode?.dispose();
    codeTextController?.dispose();
  }
}
