import '/backend/auth/auth_session.dart';
import '/backend/auth/biometric_key_store.dart';
import '/backend/ui/api_feedback.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'login_screen_model.dart';
export 'login_screen_model.dart';

class LoginScreenWidget extends StatefulWidget {
  const LoginScreenWidget({super.key});

  static String routeName = 'LoginScreen';
  static String routePath = '/loginScreen';

  @override
  State<LoginScreenWidget> createState() => _LoginScreenWidgetState();
}

class _LoginScreenWidgetState extends State<LoginScreenWidget> {
  late LoginScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginScreenModel());

    // After the first frame, so the prompt has a mounted route to sit over and
    // `ApiFeedback` has a context that can show a sheet.
    WidgetsBinding.instance.addPostFrameCallback((_) => _offerBiometrics());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  // ── Actions ───────────────────────────────────────────────────────────────────

  /// Raises the biometric prompt by itself, on a handset that has a key.
  ///
  /// The order the design asks for: face or fingerprint if it is set up, passcode if not,
  /// password as the way back in on a phone that knows neither. The two buttons stay on
  /// screen throughout, so dismissing the prompt lands on a screen that already offers
  /// the alternatives rather than on one that has to be recovered from.
  Future<void> _offerBiometrics() async {
    if (_model.hasOfferedBiometrics) return;
    _model.hasOfferedBiometrics = true;

    if (!await AuthSession.instance.hasBiometricKey()) return;
    if (!mounted) return;

    safeSetState(() => _model.hasBiometricKey = true);

    await _signInWithBiometrics(automatic: true);
  }

  /// Challenge, signature, session.
  ///
  /// [automatic] separates the prompt the screen raised on arrival from one the user
  /// asked for. A silent refusal is right for the first — they did not ask, and a sheet
  /// explaining a prompt they dismissed on purpose is noise — and wrong for the second.
  Future<void> _signInWithBiometrics({bool automatic = false}) async {
    if (_model.isSigningIn) return;

    final feedback = ApiFeedback.of(context);

    safeSetState(() => _model.isSigningIn = true);

    final outcome = await AuthSession.instance.signInWithBiometrics();

    if (!mounted) return;
    safeSetState(() => _model.isSigningIn = false);

    switch (outcome) {
      case BiometricSignedIn():
        // Replaces the stack rather than stacking on it, so Back does not return to a
        // sign-in screen for a session that is already open.
        context.goNamed(BottomBarPagesWidget.routeName);

      case BiometricPromptRefused(:final reason):
        // A key the phone destroyed is worth saying out loud even when nobody asked:
        // the option disappears, and without a word the screen would look broken.
        if (reason == BiometricUnavailable.keyInvalidated) {
          safeSetState(() => _model.hasBiometricKey = false);
          await feedback.notice(
            BiometricKeyStore.describe(reason),
            isError: true,
          );

          return;
        }

        if (automatic || reason == BiometricUnavailable.cancelled) return;

        await feedback.notice(BiometricKeyStore.describe(reason), isError: true);

      case BiometricNotEnrolled(:final result):
        // The server has no key for this device — revoked elsewhere, or this install is
        // not the one that enrolled. The passcode and password still work, so the option
        // is withdrawn instead of being offered again on every visit.
        safeSetState(() => _model.hasBiometricKey = false);

        if (automatic) return;

        await feedback.show(result);

      case BiometricSignatureRefused(:final result):
        // Said out loud even when the screen raised the prompt itself. The owner has just
        // authenticated and is watching for something to happen; silence here reads as a
        // broken sensor. The option stays — the usual cause is a challenge that went
        // stale while the phone sat on the desk, and trying again is the whole fix.
        await feedback.show(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).primaryBackground,
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: double.infinity,
                    height: 570.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: Image.asset(
                          'assets/images/BG.png',
                        ).image,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 483.79,
                      decoration: BoxDecoration(),
                      alignment: AlignmentDirectional(0.0, 1.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            width: 130.0,
                            height: 130.0,
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: Image.asset(
                              'assets/images/Text.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 12.0, 0.0, 0.0),
                            child: Text(
                              'Welcome Back',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                          Text(
                            'Lipper Piiza',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  fontSize: 42.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 8.0, 0.0, 0.0),
                            child: Text(
                              'Login to your account',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: Color(0x64FFFFFF),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 35.0),
                      child: Container(
                        decoration: BoxDecoration(),
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              15.0, 0.0, 15.0, 0.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              // Only on a handset that has a key. The prompt already
                              // came up by itself on arrival; this is the way back to it
                              // for somebody who dismissed it and changed their mind,
                              // which otherwise means closing and reopening the app.
                              if (_model.hasBiometricKey)
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 16.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      await _signInWithBiometrics();
                                    },
                                    child: Text(
                                      'Use biometric sign-in',
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .titleMedium
                                          .override(
                                            font: GoogleFonts.interTight(
                                              fontWeight: FontWeight.w500,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .titleMedium
                                                      .fontStyle,
                                            ),
                                            color: Colors.white,
                                            fontSize: 16.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ),
                                ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  context
                                      .pushNamed(PasswardLoginWidget.routeName);
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 52.0,
                                  decoration: BoxDecoration(
                                    color: Color(0x63000000),
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 18.4,
                                        color: Color(0x0F000000),
                                        offset: Offset(
                                          0.0,
                                          7.0,
                                        ),
                                        spreadRadius: 0.0,
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(106.67),
                                    border: Border.all(
                                      color: Color(0x45FFFFFF),
                                      width: 1.0,
                                    ),
                                  ),
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Text(
                                    'Login with Password',
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          font: GoogleFonts.interTight(
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .fontStyle,
                                          ),
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleMedium
                                                  .fontStyle,
                                          lineHeight: 1.44,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                              InkWell(
                                splashColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                hoverColor: Colors.transparent,
                                highlightColor: Colors.transparent,
                                onTap: () async {
                                  context
                                      .pushNamed(PassCodeLoginWidget.routeName);
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 52.0,
                                  decoration: BoxDecoration(
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    boxShadow: [
                                      BoxShadow(
                                        blurRadius: 18.4,
                                        color: Color(0x0F000000),
                                        offset: Offset(
                                          0.0,
                                          7.0,
                                        ),
                                        spreadRadius: 0.0,
                                      )
                                    ],
                                    borderRadius: BorderRadius.circular(106.67),
                                    border: Border.all(
                                      color: Color(0x45FFFFFF),
                                      width: 1.0,
                                    ),
                                  ),
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Text(
                                    'Login with Passcode',
                                    textAlign: TextAlign.center,
                                    maxLines: 1,
                                    style: FlutterFlowTheme.of(context)
                                        .titleMedium
                                        .override(
                                          font: GoogleFonts.interTight(
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .titleMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          fontSize: 18.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .titleMedium
                                                  .fontStyle,
                                          lineHeight: 1.44,
                                        ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ].divide(SizedBox(height: 12.0)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
