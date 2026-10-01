import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'pass_code_login_model.dart';
export 'pass_code_login_model.dart';

class PassCodeLoginWidget extends StatefulWidget {
  const PassCodeLoginWidget({super.key});

  static String routeName = 'PassCodeLogin';
  static String routePath = '/passCodeLogin';

  @override
  State<PassCodeLoginWidget> createState() => _PassCodeLoginWidgetState();
}

class _PassCodeLoginWidgetState extends State<PassCodeLoginWidget> {
  late PassCodeLoginModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PassCodeLoginModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
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
            color: Colors.black,
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: double.infinity,
                    height: 162.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: Image.asset(
                          'assets/images/GreenPageBg.png',
                        ).image,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 67.0, 0.0, 0.0),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        // Opened from the sign-in screen, Back returns there. Opened as
                                        // the lock on a restored session there is nothing underneath, and
                                        // Back offers the other ways in rather than the sign-up flow.
                                        if (Navigator.of(context).canPop()) {
                                          context.pop();
                                        } else {
                                          context.goNamed(
                                              LoginScreenWidget.routeName);
                                        }
                                      },
                                      child: Icon(
                                        Icons.arrow_back,
                                        color: FlutterFlowTheme.of(context)
                                            .primaryText,
                                        size: 24.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 19.0, 0.0, 0.0),
                                child: Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 10.0, 0.0, 0.0),
                                        child: Container(
                                          decoration: BoxDecoration(),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Enter passcode',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      fontSize: 30.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                              ),
                                              Text(
                                                'Enter your passcode to unlock the app.',
                                                style: FlutterFlowTheme.of(
                                                        context)
                                                    .bodyMedium
                                                    .override(
                                                      font: GoogleFonts.inter(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      color: Color(0xFFEBEBEB),
                                                      fontSize: 15.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                      lineHeight: 1.3,
                                                    ),
                                              ),
                                            ].divide(SizedBox(height: 9.0)),
                                          ),
                                        ),
                                      ),
                                    ].divide(SizedBox(height: 24.0)),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 135.0, 0.0, 0.0),
                                child: Container(
                                  width: MediaQuery.sizeOf(context).width * 0.8,
                                  height: 100.0,
                                  decoration: BoxDecoration(),
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 16.0,
                                        height: 16.0,
                                        decoration: BoxDecoration(
                                          color: functions.isPinDotFilled(
                                                  _model.pinCode, 0)
                                              ? FlutterFlowTheme.of(context)
                                                  .primaryText
                                              : Color(0x00000000),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Color(0xFFE7E7E7),
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 16.0,
                                        height: 16.0,
                                        decoration: BoxDecoration(
                                          color: functions.isPinDotFilled(
                                                  _model.pinCode, 1)
                                              ? FlutterFlowTheme.of(context)
                                                  .primaryText
                                              : Color(0x00000000),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Color(0xFFE7E7E7),
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 16.0,
                                        height: 16.0,
                                        decoration: BoxDecoration(
                                          color: functions.isPinDotFilled(
                                                  _model.pinCode, 2)
                                              ? FlutterFlowTheme.of(context)
                                                  .primaryText
                                              : Color(0x00000000),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Color(0xFFE7E7E7),
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 16.0,
                                        height: 16.0,
                                        decoration: BoxDecoration(
                                          color: functions.isPinDotFilled(
                                                  _model.pinCode, 3)
                                              ? FlutterFlowTheme.of(context)
                                                  .primaryText
                                              : Color(0x00000000),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Color(0xFFE7E7E7),
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 16.0,
                                        height: 16.0,
                                        decoration: BoxDecoration(
                                          color: functions.isPinDotFilled(
                                                  _model.pinCode, 4)
                                              ? FlutterFlowTheme.of(context)
                                                  .primaryText
                                              : Color(0x00000000),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Color(0xFFE7E7E7),
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: 16.0,
                                        height: 16.0,
                                        decoration: BoxDecoration(
                                          color: functions.isPinDotFilled(
                                                  _model.pinCode, 5)
                                              ? FlutterFlowTheme.of(context)
                                                  .primaryText
                                              : Color(0x00000000),
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Color(0xFFE7E7E7),
                                            width: 1.0,
                                          ),
                                        ),
                                      ),
                                    ].divide(SizedBox(width: 10.0)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 0.0, 0.0, 50.0),
                          child: Container(
                            width: double.infinity,
                            height: 399.3,
                            decoration: BoxDecoration(),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        if (_model.isSubmitting == false) {
                                          _model.pinCode =
                                              functions.appendPinDigit(
                                                  _model.pinCode, '1', 6);
                                          safeSetState(() {});
                                          if (functions.isPinComplete(
                                              _model.pinCode, 6)) {
                                            _model.isSubmitting = true;
                                            safeSetState(() {});
                                            _model.passcodeSignInaamy74vi =
                                                await actions
                                                    .haatSignInWithPasscode(
                                              _model.pinCode,
                                            );
                                            _model.isSubmitting = false;
                                            safeSetState(() {});
                                            _model.pinCode = '';
                                            safeSetState(() {});
                                            if (_model.passcodeSignInaamy74vi ==
                                                '') {
                                              context.goNamed(BottomBarPagesWidget.routeName);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    _model
                                                        .passcodeSignInaamy74vi!,
                                                    style: TextStyle(),
                                                  ),
                                                  duration: Duration(
                                                      milliseconds: 4000),
                                                ),
                                              );
                                            }
                                          }
                                        }

                                        safeSetState(() {});
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  15.0, 0.0, 15.0, 0.0),
                                          child: Text(
                                            '1',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  fontSize: 32.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
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
                                        if (_model.isSubmitting == false) {
                                          _model.pinCode =
                                              functions.appendPinDigit(
                                                  _model.pinCode, '2', 6);
                                          safeSetState(() {});
                                          if (functions.isPinComplete(
                                              _model.pinCode, 6)) {
                                            _model.isSubmitting = true;
                                            safeSetState(() {});
                                            _model.passcodeSignInow8ohec3 =
                                                await actions
                                                    .haatSignInWithPasscode(
                                              _model.pinCode,
                                            );
                                            _model.isSubmitting = false;
                                            safeSetState(() {});
                                            _model.pinCode = '';
                                            safeSetState(() {});
                                            if (_model.passcodeSignInow8ohec3 ==
                                                '') {
                                              context.goNamed(BottomBarPagesWidget.routeName);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    _model
                                                        .passcodeSignInow8ohec3!,
                                                    style: TextStyle(),
                                                  ),
                                                  duration: Duration(
                                                      milliseconds: 4000),
                                                ),
                                              );
                                            }
                                          }
                                        }

                                        safeSetState(() {});
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  15.0, 0.0, 15.0, 0.0),
                                          child: Text(
                                            '2',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  fontSize: 32.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
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
                                        if (_model.isSubmitting == false) {
                                          _model.pinCode =
                                              functions.appendPinDigit(
                                                  _model.pinCode, '3', 6);
                                          safeSetState(() {});
                                          if (functions.isPinComplete(
                                              _model.pinCode, 6)) {
                                            _model.isSubmitting = true;
                                            safeSetState(() {});
                                            _model.passcodeSignIn3ew0os73 =
                                                await actions
                                                    .haatSignInWithPasscode(
                                              _model.pinCode,
                                            );
                                            _model.isSubmitting = false;
                                            safeSetState(() {});
                                            _model.pinCode = '';
                                            safeSetState(() {});
                                            if (_model.passcodeSignIn3ew0os73 ==
                                                '') {
                                              context.goNamed(BottomBarPagesWidget.routeName);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    _model
                                                        .passcodeSignIn3ew0os73!,
                                                    style: TextStyle(),
                                                  ),
                                                  duration: Duration(
                                                      milliseconds: 4000),
                                                ),
                                              );
                                            }
                                          }
                                        }

                                        safeSetState(() {});
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  15.0, 0.0, 15.0, 0.0),
                                          child: Text(
                                            '3',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  fontSize: 32.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        if (_model.isSubmitting == false) {
                                          _model.pinCode =
                                              functions.appendPinDigit(
                                                  _model.pinCode, '4', 6);
                                          safeSetState(() {});
                                          if (functions.isPinComplete(
                                              _model.pinCode, 6)) {
                                            _model.isSubmitting = true;
                                            safeSetState(() {});
                                            _model.passcodeSignIn743xths0 =
                                                await actions
                                                    .haatSignInWithPasscode(
                                              _model.pinCode,
                                            );
                                            _model.isSubmitting = false;
                                            safeSetState(() {});
                                            _model.pinCode = '';
                                            safeSetState(() {});
                                            if (_model.passcodeSignIn743xths0 ==
                                                '') {
                                              context.goNamed(BottomBarPagesWidget.routeName);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    _model
                                                        .passcodeSignIn743xths0!,
                                                    style: TextStyle(),
                                                  ),
                                                  duration: Duration(
                                                      milliseconds: 4000),
                                                ),
                                              );
                                            }
                                          }
                                        }

                                        safeSetState(() {});
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  15.0, 0.0, 15.0, 0.0),
                                          child: Text(
                                            '4',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  fontSize: 32.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
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
                                        if (_model.isSubmitting == false) {
                                          _model.pinCode =
                                              functions.appendPinDigit(
                                                  _model.pinCode, '5', 6);
                                          safeSetState(() {});
                                          if (functions.isPinComplete(
                                              _model.pinCode, 6)) {
                                            _model.isSubmitting = true;
                                            safeSetState(() {});
                                            _model.passcodeSignInwbfh2jjb =
                                                await actions
                                                    .haatSignInWithPasscode(
                                              _model.pinCode,
                                            );
                                            _model.isSubmitting = false;
                                            safeSetState(() {});
                                            _model.pinCode = '';
                                            safeSetState(() {});
                                            if (_model.passcodeSignInwbfh2jjb ==
                                                '') {
                                              context.goNamed(BottomBarPagesWidget.routeName);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    _model
                                                        .passcodeSignInwbfh2jjb!,
                                                    style: TextStyle(),
                                                  ),
                                                  duration: Duration(
                                                      milliseconds: 4000),
                                                ),
                                              );
                                            }
                                          }
                                        }

                                        safeSetState(() {});
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  15.0, 0.0, 15.0, 0.0),
                                          child: Text(
                                            '5',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  fontSize: 32.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
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
                                        if (_model.isSubmitting == false) {
                                          _model.pinCode =
                                              functions.appendPinDigit(
                                                  _model.pinCode, '6', 6);
                                          safeSetState(() {});
                                          if (functions.isPinComplete(
                                              _model.pinCode, 6)) {
                                            _model.isSubmitting = true;
                                            safeSetState(() {});
                                            _model.passcodeSignInb7p8p1a9 =
                                                await actions
                                                    .haatSignInWithPasscode(
                                              _model.pinCode,
                                            );
                                            _model.isSubmitting = false;
                                            safeSetState(() {});
                                            _model.pinCode = '';
                                            safeSetState(() {});
                                            if (_model.passcodeSignInb7p8p1a9 ==
                                                '') {
                                              context.goNamed(BottomBarPagesWidget.routeName);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    _model
                                                        .passcodeSignInb7p8p1a9!,
                                                    style: TextStyle(),
                                                  ),
                                                  duration: Duration(
                                                      milliseconds: 4000),
                                                ),
                                              );
                                            }
                                          }
                                        }

                                        safeSetState(() {});
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  15.0, 0.0, 15.0, 0.0),
                                          child: Text(
                                            '6',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  fontSize: 32.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        if (_model.isSubmitting == false) {
                                          _model.pinCode =
                                              functions.appendPinDigit(
                                                  _model.pinCode, '7', 6);
                                          safeSetState(() {});
                                          if (functions.isPinComplete(
                                              _model.pinCode, 6)) {
                                            _model.isSubmitting = true;
                                            safeSetState(() {});
                                            _model.passcodeSignIn51ajygc9 =
                                                await actions
                                                    .haatSignInWithPasscode(
                                              _model.pinCode,
                                            );
                                            _model.isSubmitting = false;
                                            safeSetState(() {});
                                            _model.pinCode = '';
                                            safeSetState(() {});
                                            if (_model.passcodeSignIn51ajygc9 ==
                                                '') {
                                              context.goNamed(BottomBarPagesWidget.routeName);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    _model
                                                        .passcodeSignIn51ajygc9!,
                                                    style: TextStyle(),
                                                  ),
                                                  duration: Duration(
                                                      milliseconds: 4000),
                                                ),
                                              );
                                            }
                                          }
                                        }

                                        safeSetState(() {});
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  15.0, 0.0, 15.0, 0.0),
                                          child: Text(
                                            '7',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  fontSize: 32.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
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
                                        if (_model.isSubmitting == false) {
                                          _model.pinCode =
                                              functions.appendPinDigit(
                                                  _model.pinCode, '8', 6);
                                          safeSetState(() {});
                                          if (functions.isPinComplete(
                                              _model.pinCode, 6)) {
                                            _model.isSubmitting = true;
                                            safeSetState(() {});
                                            _model.passcodeSignInitbkegeb =
                                                await actions
                                                    .haatSignInWithPasscode(
                                              _model.pinCode,
                                            );
                                            _model.isSubmitting = false;
                                            safeSetState(() {});
                                            _model.pinCode = '';
                                            safeSetState(() {});
                                            if (_model.passcodeSignInitbkegeb ==
                                                '') {
                                              context.goNamed(BottomBarPagesWidget.routeName);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    _model
                                                        .passcodeSignInitbkegeb!,
                                                    style: TextStyle(),
                                                  ),
                                                  duration: Duration(
                                                      milliseconds: 4000),
                                                ),
                                              );
                                            }
                                          }
                                        }

                                        safeSetState(() {});
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  15.0, 0.0, 15.0, 0.0),
                                          child: Text(
                                            '8',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  fontSize: 32.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
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
                                        if (_model.isSubmitting == false) {
                                          _model.pinCode =
                                              functions.appendPinDigit(
                                                  _model.pinCode, '9', 6);
                                          safeSetState(() {});
                                          if (functions.isPinComplete(
                                              _model.pinCode, 6)) {
                                            _model.isSubmitting = true;
                                            safeSetState(() {});
                                            _model.passcodeSignIn9vhvvnct =
                                                await actions
                                                    .haatSignInWithPasscode(
                                              _model.pinCode,
                                            );
                                            _model.isSubmitting = false;
                                            safeSetState(() {});
                                            _model.pinCode = '';
                                            safeSetState(() {});
                                            if (_model.passcodeSignIn9vhvvnct ==
                                                '') {
                                              context.goNamed(BottomBarPagesWidget.routeName);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    _model
                                                        .passcodeSignIn9vhvvnct!,
                                                    style: TextStyle(),
                                                  ),
                                                  duration: Duration(
                                                      milliseconds: 4000),
                                                ),
                                              );
                                            }
                                          }
                                        }

                                        safeSetState(() {});
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(),
                                        child: Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  15.0, 0.0, 15.0, 0.0),
                                          child: Text(
                                            '9',
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  fontSize: 32.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: MediaQuery.sizeOf(context).width *
                                          0.526,
                                      decoration: BoxDecoration(),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              if (_model.isSubmitting ==
                                                  false) {
                                                _model.pinCode =
                                                    functions.appendPinDigit(
                                                        _model.pinCode, '0', 6);
                                                safeSetState(() {});
                                                if (functions.isPinComplete(
                                                    _model.pinCode, 6)) {
                                                  _model.isSubmitting = true;
                                                  safeSetState(() {});
                                                  _model.passcodeSignInfhzn9ofb =
                                                      await actions
                                                          .haatSignInWithPasscode(
                                                    _model.pinCode,
                                                  );
                                                  _model.isSubmitting = false;
                                                  safeSetState(() {});
                                                  _model.pinCode = '';
                                                  safeSetState(() {});
                                                  if (_model
                                                          .passcodeSignInfhzn9ofb ==
                                                      '') {
                                                    context.goNamed(BottomBarPagesWidget.routeName);
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      SnackBar(
                                                        content: Text(
                                                          _model
                                                              .passcodeSignInfhzn9ofb!,
                                                          style: TextStyle(),
                                                        ),
                                                        duration: Duration(
                                                            milliseconds: 4000),
                                                      ),
                                                    );
                                                  }
                                                }
                                              }

                                              safeSetState(() {});
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        15.0, 0.0, 15.0, 0.0),
                                                child: Text(
                                                  '0',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts.inter(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        fontSize: 32.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
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
                                              _model.pinCode =
                                                  functions.removeLastPinDigit(
                                                      _model.pinCode);
                                              safeSetState(() {});
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        15.0, 0.0, 15.0, 0.0),
                                                child: Icon(
                                                  Icons.backspace_outlined,
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryText,
                                                  size: 24.0,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
