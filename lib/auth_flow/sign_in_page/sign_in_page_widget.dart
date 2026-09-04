import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/backend/api/api_envelope.dart';
import '/backend/api/api_result.dart';
import '/backend/api/auth_api.dart';
import '/backend/auth/auth_session.dart';
import '/backend/ui/api_feedback.dart';
import '/index.dart';
import 'sign_in_page_model.dart';

export 'sign_in_page_model.dart';

/// Signing back in.
///
/// The designs cover registering but not returning, and an app that can only be
/// installed once is not finished — so this follows the sign-up screens' language
/// rather than introducing a second look: the same dark ground, the same pill button,
/// the same field treatment.
///
/// It handles the three answers a sign-in can get besides yes and no, because each
/// needs somewhere different to go:
///
/// - a second factor is owed, so the same screen becomes a code prompt;
/// - the account is locked, so the button counts down instead of inviting an attempt
///   that is certain to fail;
/// - the password was set by an employer, so the user is sent to replace it before
///   anything else.
class SignInPageWidget extends StatefulWidget {
  const SignInPageWidget({super.key});

  static String routeName = 'SignInPage';
  static String routePath = '/signIn';

  @override
  State<SignInPageWidget> createState() => _SignInPageWidgetState();
}

class _SignInPageWidgetState extends State<SignInPageWidget> {
  late SignInPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  /// Ticks down a lockout. Held so it can be cancelled on dispose.
  Timer? _lockTimer;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SignInPageModel());

    _model.identifierTextController ??= TextEditingController();
    _model.identifierFocusNode ??= FocusNode();
    _model.passwordTextController ??= TextEditingController();
    _model.passwordFocusNode ??= FocusNode();
    _model.codeTextController ??= TextEditingController();
    _model.codeFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _lockTimer?.cancel();
    _model.dispose();

    super.dispose();
  }

  // ── Actions ─────────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    if (!_model.canSubmit) return;

    final typed = _model.identifierTextController!.text.trim();
    final password = _model.passwordTextController!.text;
    final feedback = ApiFeedback.of(context);

    safeSetState(() => _model.isSubmitting = true);

    final result = await switch (_model.identifier) {
      SignInIdentifier.mobile => AuthSession.instance.signIn(
          mobile: PhoneFormat.toE164(typed),
          password: password,
        ),
      // One field for two kinds of identifier, told apart by the '@'. The backend
      // refuses a request that names both, so the app has to choose one.
      SignInIdentifier.handle => typed.contains('@')
          ? AuthSession.instance.signIn(email: typed, password: password)
          : AuthSession.instance.signIn(username: typed, password: password),
    };

    if (!mounted) return;
    safeSetState(() => _model.isSubmitting = false);

    await _handleOutcome(result, feedback);
  }

  Future<void> _submitCode() async {
    final token = _model.mfaToken;
    final code = _model.codeTextController!.text.trim();

    if (token == null || code.length < 6 || _model.isSubmitting) return;

    final feedback = ApiFeedback.of(context);
    safeSetState(() => _model.isSubmitting = true);

    final result =
        await AuthSession.instance.verifyMfa(mfaToken: token, code: code);

    if (!mounted) return;
    safeSetState(() => _model.isSubmitting = false);

    await _handleOutcome(result, feedback);
  }

  Future<void> _handleOutcome(
    ApiResult<AuthTokens> result,
    ApiFeedback feedback,
  ) async {
    switch (result) {
      case ApiSuccess<AuthTokens>(:final value):
        if (value.mustChangePassword) {
          // An employer chose this password and has read it. It is not a secret
          // between the account and its owner until the owner replaces it.
          feedback.notice('Please choose your own password to continue.');
          context.goNamed(CreatePasswordPageWidget.routeName);
          return;
        }

        context.goNamed(BottomBarPagesWidget.routeName);

      case ApiFailure<AuthTokens>(:final envelope):
        switch (envelope.errorCode) {
          case ApiErrorCode.mfaRequired:
            safeSetState(() {
              _model.mfaToken = envelope.object['mfaToken'] as String?;
              _model.codeTextController?.clear();
            });
            _model.codeFocusNode?.requestFocus();

          case ApiErrorCode.accountLocked:
            _startLockCountdown(envelope.object['retryAfterSeconds']);
            feedback.show(result);

          default:
            feedback.show(result);
        }

      case ApiUnreachable<AuthTokens>():
        feedback.show(result);
    }
  }

  /// Counts a lockout down so the button can say when it is worth trying again.
  void _startLockCountdown(dynamic retryAfterSeconds) {
    final seconds = switch (retryAfterSeconds) {
      final int value => value,
      final String value => int.tryParse(value) ?? 0,
      _ => 0,
    };

    if (seconds <= 0) return;

    _lockTimer?.cancel();
    safeSetState(() => _model.lockedForSeconds = seconds);

    _lockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      safeSetState(() => _model.lockedForSeconds -= 1);
      if (_model.lockedForSeconds <= 0) timer.cancel();
    });
  }

  void _switchIdentifier(SignInIdentifier to) {
    if (_model.identifier == to) return;

    safeSetState(() {
      _model.identifier = to;
      // Cleared rather than carried over: a phone number is not a username, and
      // leaving the old text in place makes the field look already filled in.
      _model.identifierTextController?.clear();
    });
    _model.identifierFocusNode?.requestFocus();
  }

  // ── Building ────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final awaitingCode = _model.mfaToken != null;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: theme.primaryBackground,
        body: SafeArea(
          child: Stack(
            children: [
              // The same header treatment the sign-up screens open with.
              Container(
                width: double.infinity,
                height: 162.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: Image.asset('assets/images/GreenPageBg.png').image,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(15, 0, 15, 0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 60),
                            _backButton(theme),
                            const SizedBox(height: 28),
                            Text(
                              awaitingCode ? 'Enter your code' : 'Welcome back',
                              style: theme.headlineMedium.override(
                                font: GoogleFonts.interTight(
                                  fontWeight: FontWeight.w600,
                                ),
                                color: theme.primaryText,
                                fontSize: 28,
                                letterSpacing: 0,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              awaitingCode
                                  ? 'Open your authenticator app and enter the six-digit code.'
                                  : 'Sign in to get back to your business.',
                              style: theme.bodyMedium.override(
                                font: GoogleFonts.inter(),
                                color: theme.secondaryText,
                                fontSize: 14,
                                letterSpacing: 0,
                                lineHeight: 1.4,
                              ),
                            ),
                            const SizedBox(height: 32),
                            if (awaitingCode)
                              ..._codeFields(theme)
                            else
                              ..._credentialFields(theme),
                          ],
                        ),
                      ),
                    ),
                    // A gap the layout cannot eat: with the keyboard up the scroll
                    // area shrinks to its content, and without this the button ends
                    // up touching the field above it.
                    const SizedBox(height: 20),
                    _primaryButton(theme, awaitingCode: awaitingCode),
                    if (!awaitingCode) _signUpLink(theme),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _backButton(FlutterFlowTheme theme) => InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          if (_model.mfaToken != null) {
            // Back out of the code step to the password step rather than off the
            // screen: the user has not signed in yet and may have picked the wrong
            // account.
            safeSetState(() => _model.mfaToken = null);
            return;
          }

          if (context.canPop()) {
            context.pop();
          } else {
            context.goNamed(OnBoardingPageWidget.routeName);
          }
        },
        child: Icon(Icons.arrow_back, color: theme.primaryText, size: 24),
      );

  List<Widget> _credentialFields(FlutterFlowTheme theme) => [
        _identifierToggle(theme),
        const SizedBox(height: 20),
        _field(
          theme: theme,
          label: _model.identifierLabel,
          hint: _model.identifierHint,
          controller: _model.identifierTextController!,
          focusNode: _model.identifierFocusNode!,
          keyboardType: _model.identifierKeyboard,
          textInputAction: TextInputAction.next,
          onSubmitted: () async => _model.passwordFocusNode?.requestFocus(),
          prefix: _model.identifier == SignInIdentifier.mobile
              ? Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(14, 0, 0, 0),
                  child: Text(
                    PhoneFormat.dialCode,
                    style: theme.bodyMedium.override(
                      font: GoogleFonts.inter(),
                      color: theme.primaryText,
                      letterSpacing: 0,
                    ),
                  ),
                )
              : null,
          inputFormatters: _model.identifier == SignInIdentifier.mobile
              ? [FilteringTextInputFormatter.digitsOnly]
              : null,
          onChanged: () => safeSetState(() {}),
        ),
        const SizedBox(height: 16),
        _field(
          theme: theme,
          label: 'Password',
          hint: '••••••••',
          controller: _model.passwordTextController!,
          focusNode: _model.passwordFocusNode!,
          obscure: !_model.passwordVisible,
          textInputAction: TextInputAction.done,
          onSubmitted: _submit,
          onChanged: () => safeSetState(() {}),
          suffix: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () => safeSetState(
              () => _model.passwordVisible = !_model.passwordVisible,
            ),
            child: Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 14, 0),
              child: Icon(
                _model.passwordVisible
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: theme.secondaryText,
                size: 20,
              ),
            ),
          ),
        ),
      ];

  List<Widget> _codeFields(FlutterFlowTheme theme) => [
        _field(
          theme: theme,
          label: 'Six-digit code',
          hint: '000000',
          controller: _model.codeTextController!,
          focusNode: _model.codeFocusNode!,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(6),
          ],
          onChanged: () => safeSetState(() {}),
          onSubmitted: _submitCode,
        ),
      ];

  /// Phone or handle. Two segments rather than a dropdown: there are only ever two, and
  /// both should be one tap away for the person who needs the less common one.
  Widget _identifierToggle(FlutterFlowTheme theme) => Container(
        decoration: BoxDecoration(
          color: theme.secondary,
          borderRadius: BorderRadius.circular(106.67),
        ),
        padding: const EdgeInsets.all(4),
        child: Row(
          children: [
            _toggleSegment(theme, 'Phone', SignInIdentifier.mobile),
            _toggleSegment(theme, 'Username', SignInIdentifier.handle),
          ],
        ),
      );

  Widget _toggleSegment(
    FlutterFlowTheme theme,
    String label,
    SignInIdentifier value,
  ) {
    final selected = _model.identifier == value;

    return Expanded(
      child: InkWell(
        splashColor: Colors.transparent,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () => _switchIdentifier(value),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: selected ? theme.primaryText : Colors.transparent,
            borderRadius: BorderRadius.circular(106.67),
          ),
          alignment: AlignmentDirectional.center,
          child: Text(
            label,
            style: theme.bodyMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w500),
              color: selected ? theme.primaryBackground : theme.primaryText,
              fontSize: 14,
              letterSpacing: 0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _field({
    required FlutterFlowTheme theme,
    required String label,
    required String hint,
    required TextEditingController controller,
    required FocusNode focusNode,
    bool obscure = false,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
    List<TextInputFormatter>? inputFormatters,
    Widget? prefix,
    Widget? suffix,
    VoidCallback? onChanged,
    Future<void> Function()? onSubmitted,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.labelMedium.override(
              font: GoogleFonts.inter(fontWeight: FontWeight.w500),
              color: theme.secondaryText,
              fontSize: 12,
              letterSpacing: 0,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: theme.secondary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                if (prefix != null) prefix,
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    focusNode: focusNode,
                    obscureText: obscure,
                    keyboardType: keyboardType,
                    textInputAction: textInputAction,
                    inputFormatters: inputFormatters,
                    onChanged: (_) => onChanged?.call(),
                    onFieldSubmitted: (_) => onSubmitted?.call(),
                    style: theme.bodyLarge.override(
                      font: GoogleFonts.inter(),
                      color: theme.primaryText,
                      letterSpacing: 0,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: hint,
                      hintStyle: theme.bodyLarge.override(
                        font: GoogleFonts.inter(),
                        color: theme.secondaryText,
                        letterSpacing: 0,
                      ),
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      contentPadding:
                          const EdgeInsetsDirectional.fromSTEB(14, 16, 14, 16),
                    ),
                  ),
                ),
                if (suffix != null) suffix,
              ],
            ),
          ),
        ],
      );

  Widget _primaryButton(FlutterFlowTheme theme, {required bool awaitingCode}) {
    final enabled = awaitingCode
        ? (_model.codeTextController!.text.trim().length == 6 &&
            !_model.isSubmitting)
        : _model.canSubmit;

    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async => awaitingCode ? await _submitCode() : await _submit(),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: enabled ? theme.primaryText : theme.secondary,
          borderRadius: BorderRadius.circular(106.67),
        ),
        alignment: AlignmentDirectional.center,
        child: _model.isSubmitting
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(theme.primaryBackground),
                ),
              )
            : Text(
                // A locked account gets a countdown rather than a button that will
                // certainly be refused.
                _model.isLocked
                    ? 'Try again in ${_model.lockedForSeconds}s'
                    : (awaitingCode ? 'Verify' : 'Sign in'),
                style: theme.bodyMedium.override(
                  font: GoogleFonts.inter(fontWeight: FontWeight.w500),
                  color: enabled ? theme.primaryBackground : theme.primary,
                  fontSize: 18,
                  letterSpacing: 0,
                  fontWeight: FontWeight.w500,
                ),
              ),
      ),
    );
  }

  Widget _signUpLink(FlutterFlowTheme theme) => Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
        child: InkWell(
          splashColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onTap: () => context.pushNamed(PhoneNumberPageWidget.routeName),
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'New to HAAT? ',
                  style: theme.bodyMedium.override(
                    font: GoogleFonts.inter(),
                    color: theme.secondaryText,
                    fontSize: 14,
                    letterSpacing: 0,
                  ),
                ),
                TextSpan(
                  text: 'Create an account',
                  style: theme.bodyMedium.override(
                    font: GoogleFonts.inter(fontWeight: FontWeight.w600),
                    color: theme.tertiary,
                    fontSize: 14,
                    letterSpacing: 0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
