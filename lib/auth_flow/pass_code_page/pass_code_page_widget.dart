import '/flutter_flow/ff_builtin_enums.dart';
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
import 'pass_code_page_model.dart';
export 'pass_code_page_model.dart';

class PassCodePageWidget extends StatefulWidget {
  const PassCodePageWidget({super.key});

  static String routeName = 'PassCodePage';
  static String routePath = '/passCodePage';

  @override
  State<PassCodePageWidget> createState() => _PassCodePageWidgetState();
}

class _PassCodePageWidgetState extends State<PassCodePageWidget> {
  late PassCodePageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => PassCodePageModel());
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
        body: Builder(
          builder: (context) {
            if (_model.reenterPin == false) {
              return Container(
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
                        padding: EdgeInsetsDirectional.fromSTEB(
                            15.0, 0.0, 15.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            (FFMainAxisAlignment.spaceBetween)
                                                .flutterValue,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 67.0, 0.0, 0.0),
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        0.17,
                                                    height: 3.0,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2.0),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        0.17,
                                                    height: 3.0,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2.0),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        0.17,
                                                    height: 3.0,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2.0),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        0.17,
                                                    height: 3.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0x4CFFFFFF),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2.0),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        0.17,
                                                    height: 3.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0x4DFFFFFF),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2.0),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
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
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 10.0,
                                                                0.0, 0.0),
                                                    child: Container(
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Create a passcode',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .montserrat(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  fontSize:
                                                                      30.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                          ),
                                                          Text(
                                                            'Please create a 6-digit passcode to use when logging in and approving actions.',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .montserrat(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .normal,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  color: Color(
                                                                      0xFFEBEBEB),
                                                                  fontSize:
                                                                      15.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                  lineHeight:
                                                                      1.3,
                                                                ),
                                                          ),
                                                        ].divide(SizedBox(
                                                            height: 9.0)),
                                                      ),
                                                    ),
                                                  ),
                                                ].divide(
                                                    SizedBox(height: 24.0)),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 40.0, 0.0, 0.0),
                                            child: Container(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.8,
                                              height: 100.0,
                                              decoration: BoxDecoration(),
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 16.0,
                                                    height: 16.0,
                                                    decoration: BoxDecoration(
                                                      color: functions
                                                              .isPinDotFilled(
                                                                  _model
                                                                      .pinCode,
                                                                  0)
                                                          ? FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText
                                                          : Color(0x00000000),
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color:
                                                            Color(0xFFE7E7E7),
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 16.0,
                                                    height: 16.0,
                                                    decoration: BoxDecoration(
                                                      color: functions
                                                              .isPinDotFilled(
                                                                  _model
                                                                      .pinCode,
                                                                  1)
                                                          ? FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText
                                                          : Color(0x00000000),
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color:
                                                            Color(0xFFE7E7E7),
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 16.0,
                                                    height: 16.0,
                                                    decoration: BoxDecoration(
                                                      color: functions
                                                              .isPinDotFilled(
                                                                  _model
                                                                      .pinCode,
                                                                  2)
                                                          ? FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText
                                                          : Color(0x00000000),
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color:
                                                            Color(0xFFE7E7E7),
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 16.0,
                                                    height: 16.0,
                                                    decoration: BoxDecoration(
                                                      color: functions
                                                              .isPinDotFilled(
                                                                  _model
                                                                      .pinCode,
                                                                  3)
                                                          ? FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText
                                                          : Color(0x00000000),
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color:
                                                            Color(0xFFE7E7E7),
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 16.0,
                                                    height: 16.0,
                                                    decoration: BoxDecoration(
                                                      color: functions
                                                              .isPinDotFilled(
                                                                  _model
                                                                      .pinCode,
                                                                  4)
                                                          ? FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText
                                                          : Color(0x00000000),
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color:
                                                            Color(0xFFE7E7E7),
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 16.0,
                                                    height: 16.0,
                                                    decoration: BoxDecoration(
                                                      color: functions
                                                              .isPinDotFilled(
                                                                  _model
                                                                      .pinCode,
                                                                  5)
                                                          ? FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText
                                                          : Color(0x00000000),
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color:
                                                            Color(0xFFE7E7E7),
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
                                  ],
                                ),
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
                                  mainAxisAlignment:
                                      (FFMainAxisAlignment.spaceEvenly)
                                          .flutterValue,
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
                                            _model.passcodeResult =
                                                functions.passcodeStepResult(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '1',
                                                    6);
                                            safeSetState(() {});
                                            _model.createdPasscode =
                                                functions.nextCreatedPasscode(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '1',
                                                    6);
                                            safeSetState(() {});
                                            _model.reenterPin =
                                                functions.nextReenterPin(
                                                    _model.pinCode,
                                                    _model.reenterPin,
                                                    '1',
                                                    6);
                                            safeSetState(() {});
                                            _model.pinCode =
                                                functions.nextPinCode(
                                                    _model.pinCode, '1', 6);
                                            safeSetState(() {});
                                            if (_model.passcodeResult == 2) {
                                              _model.passcodeSetpy7860vq =
                                                  await actions.haatSetPasscode(
                                                _model.createdPasscode,
                                              );
                                              if (_model.passcodeSetpy7860vq ==
                                                  '') {
                                                context.pushNamed(
                                                    BiomatricPageWidget
                                                        .routeName);

                                                if (_model.passcodeResult ==
                                                    3) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Passcode does not match. Please try again.',
                                                        style: TextStyle(),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 4000),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      _model
                                                          .passcodeSetpy7860vq!,
                                                      style: TextStyle(),
                                                    ),
                                                    duration: Duration(
                                                        milliseconds: 4000),
                                                  ),
                                                );
                                                _model.pinCode = '';
                                                safeSetState(() {});
                                                _model.createdPasscode = '';
                                                safeSetState(() {});
                                                _model.reenterPin = false;
                                                safeSetState(() {});
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
                                                '1',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .montserrat(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
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
                                            _model.passcodeResult =
                                                functions.passcodeStepResult(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '2',
                                                    6);
                                            safeSetState(() {});
                                            _model.createdPasscode =
                                                functions.nextCreatedPasscode(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '2',
                                                    6);
                                            safeSetState(() {});
                                            _model.reenterPin =
                                                functions.nextReenterPin(
                                                    _model.pinCode,
                                                    _model.reenterPin,
                                                    '2',
                                                    6);
                                            safeSetState(() {});
                                            _model.pinCode =
                                                functions.nextPinCode(
                                                    _model.pinCode, '2', 6);
                                            safeSetState(() {});
                                            if (_model.passcodeResult == 2) {
                                              _model.passcodeSetqp8u6zhy =
                                                  await actions.haatSetPasscode(
                                                _model.createdPasscode,
                                              );
                                              if (_model.passcodeSetqp8u6zhy ==
                                                  '') {
                                                context.pushNamed(
                                                    BiomatricPageWidget
                                                        .routeName);

                                                if (_model.passcodeResult ==
                                                    3) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Passcode does not match. Please try again.',
                                                        style: TextStyle(),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 4000),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      _model
                                                          .passcodeSetqp8u6zhy!,
                                                      style: TextStyle(),
                                                    ),
                                                    duration: Duration(
                                                        milliseconds: 4000),
                                                  ),
                                                );
                                                _model.pinCode = '';
                                                safeSetState(() {});
                                                _model.createdPasscode = '';
                                                safeSetState(() {});
                                                _model.reenterPin = false;
                                                safeSetState(() {});
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
                                                '2',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .montserrat(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
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
                                            _model.passcodeResult =
                                                functions.passcodeStepResult(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '3',
                                                    6);
                                            safeSetState(() {});
                                            _model.createdPasscode =
                                                functions.nextCreatedPasscode(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '3',
                                                    6);
                                            safeSetState(() {});
                                            _model.reenterPin =
                                                functions.nextReenterPin(
                                                    _model.pinCode,
                                                    _model.reenterPin,
                                                    '3',
                                                    6);
                                            safeSetState(() {});
                                            _model.pinCode =
                                                functions.nextPinCode(
                                                    _model.pinCode, '3', 6);
                                            safeSetState(() {});
                                            if (_model.passcodeResult == 2) {
                                              _model.passcodeSetcy4acqxr =
                                                  await actions.haatSetPasscode(
                                                _model.createdPasscode,
                                              );
                                              if (_model.passcodeSetcy4acqxr ==
                                                  '') {
                                                context.pushNamed(
                                                    BiomatricPageWidget
                                                        .routeName);

                                                if (_model.passcodeResult ==
                                                    3) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Passcode does not match. Please try again.',
                                                        style: TextStyle(),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 4000),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      _model
                                                          .passcodeSetcy4acqxr!,
                                                      style: TextStyle(),
                                                    ),
                                                    duration: Duration(
                                                        milliseconds: 4000),
                                                  ),
                                                );
                                                _model.pinCode = '';
                                                safeSetState(() {});
                                                _model.createdPasscode = '';
                                                safeSetState(() {});
                                                _model.reenterPin = false;
                                                safeSetState(() {});
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
                                                '3',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .montserrat(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
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
                                            _model.passcodeResult =
                                                functions.passcodeStepResult(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '4',
                                                    6);
                                            safeSetState(() {});
                                            _model.createdPasscode =
                                                functions.nextCreatedPasscode(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '4',
                                                    6);
                                            safeSetState(() {});
                                            _model.reenterPin =
                                                functions.nextReenterPin(
                                                    _model.pinCode,
                                                    _model.reenterPin,
                                                    '4',
                                                    6);
                                            safeSetState(() {});
                                            _model.pinCode =
                                                functions.nextPinCode(
                                                    _model.pinCode, '4', 6);
                                            safeSetState(() {});
                                            if (_model.passcodeResult == 2) {
                                              _model.passcodeSetiodh71kn =
                                                  await actions.haatSetPasscode(
                                                _model.createdPasscode,
                                              );
                                              if (_model.passcodeSetiodh71kn ==
                                                  '') {
                                                context.pushNamed(
                                                    BiomatricPageWidget
                                                        .routeName);

                                                if (_model.passcodeResult ==
                                                    3) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Passcode does not match. Please try again.',
                                                        style: TextStyle(),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 4000),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      _model
                                                          .passcodeSetiodh71kn!,
                                                      style: TextStyle(),
                                                    ),
                                                    duration: Duration(
                                                        milliseconds: 4000),
                                                  ),
                                                );
                                                _model.pinCode = '';
                                                safeSetState(() {});
                                                _model.createdPasscode = '';
                                                safeSetState(() {});
                                                _model.reenterPin = false;
                                                safeSetState(() {});
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
                                                '4',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .montserrat(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
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
                                            _model.passcodeResult =
                                                functions.passcodeStepResult(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '5',
                                                    6);
                                            safeSetState(() {});
                                            _model.createdPasscode =
                                                functions.nextCreatedPasscode(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '5',
                                                    6);
                                            safeSetState(() {});
                                            _model.reenterPin =
                                                functions.nextReenterPin(
                                                    _model.pinCode,
                                                    _model.reenterPin,
                                                    '5',
                                                    6);
                                            safeSetState(() {});
                                            _model.pinCode =
                                                functions.nextPinCode(
                                                    _model.pinCode, '5', 6);
                                            safeSetState(() {});
                                            if (_model.passcodeResult == 2) {
                                              _model.passcodeSete48eyjb4 =
                                                  await actions.haatSetPasscode(
                                                _model.createdPasscode,
                                              );
                                              if (_model.passcodeSete48eyjb4 ==
                                                  '') {
                                                context.pushNamed(
                                                    BiomatricPageWidget
                                                        .routeName);

                                                if (_model.passcodeResult ==
                                                    3) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Passcode does not match. Please try again.',
                                                        style: TextStyle(),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 4000),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      _model
                                                          .passcodeSete48eyjb4!,
                                                      style: TextStyle(),
                                                    ),
                                                    duration: Duration(
                                                        milliseconds: 4000),
                                                  ),
                                                );
                                                _model.pinCode = '';
                                                safeSetState(() {});
                                                _model.createdPasscode = '';
                                                safeSetState(() {});
                                                _model.reenterPin = false;
                                                safeSetState(() {});
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
                                                '5',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .montserrat(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
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
                                            _model.passcodeResult =
                                                functions.passcodeStepResult(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '6',
                                                    6);
                                            safeSetState(() {});
                                            _model.createdPasscode =
                                                functions.nextCreatedPasscode(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '6',
                                                    6);
                                            safeSetState(() {});
                                            _model.reenterPin =
                                                functions.nextReenterPin(
                                                    _model.pinCode,
                                                    _model.reenterPin,
                                                    '6',
                                                    6);
                                            safeSetState(() {});
                                            _model.pinCode =
                                                functions.nextPinCode(
                                                    _model.pinCode, '6', 6);
                                            safeSetState(() {});
                                            if (_model.passcodeResult == 2) {
                                              _model.passcodeSetkxo8m5pl =
                                                  await actions.haatSetPasscode(
                                                _model.createdPasscode,
                                              );
                                              if (_model.passcodeSetkxo8m5pl ==
                                                  '') {
                                                context.pushNamed(
                                                    BiomatricPageWidget
                                                        .routeName);

                                                if (_model.passcodeResult ==
                                                    3) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Passcode does not match. Please try again.',
                                                        style: TextStyle(),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 4000),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      _model
                                                          .passcodeSetkxo8m5pl!,
                                                      style: TextStyle(),
                                                    ),
                                                    duration: Duration(
                                                        milliseconds: 4000),
                                                  ),
                                                );
                                                _model.pinCode = '';
                                                safeSetState(() {});
                                                _model.createdPasscode = '';
                                                safeSetState(() {});
                                                _model.reenterPin = false;
                                                safeSetState(() {});
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
                                                '6',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .montserrat(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
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
                                            _model.passcodeResult =
                                                functions.passcodeStepResult(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '7',
                                                    6);
                                            safeSetState(() {});
                                            _model.createdPasscode =
                                                functions.nextCreatedPasscode(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '7',
                                                    6);
                                            safeSetState(() {});
                                            _model.reenterPin =
                                                functions.nextReenterPin(
                                                    _model.pinCode,
                                                    _model.reenterPin,
                                                    '7',
                                                    6);
                                            safeSetState(() {});
                                            _model.pinCode =
                                                functions.nextPinCode(
                                                    _model.pinCode, '7', 6);
                                            safeSetState(() {});
                                            if (_model.passcodeResult == 2) {
                                              _model.passcodeSetlxqdb44t =
                                                  await actions.haatSetPasscode(
                                                _model.createdPasscode,
                                              );
                                              if (_model.passcodeSetlxqdb44t ==
                                                  '') {
                                                context.pushNamed(
                                                    BiomatricPageWidget
                                                        .routeName);

                                                if (_model.passcodeResult ==
                                                    3) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Passcode does not match. Please try again.',
                                                        style: TextStyle(),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 4000),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      _model
                                                          .passcodeSetlxqdb44t!,
                                                      style: TextStyle(),
                                                    ),
                                                    duration: Duration(
                                                        milliseconds: 4000),
                                                  ),
                                                );
                                                _model.pinCode = '';
                                                safeSetState(() {});
                                                _model.createdPasscode = '';
                                                safeSetState(() {});
                                                _model.reenterPin = false;
                                                safeSetState(() {});
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
                                                '7',
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
                                            _model.passcodeResult =
                                                functions.passcodeStepResult(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '8',
                                                    6);
                                            safeSetState(() {});
                                            _model.createdPasscode =
                                                functions.nextCreatedPasscode(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '8',
                                                    6);
                                            safeSetState(() {});
                                            _model.reenterPin =
                                                functions.nextReenterPin(
                                                    _model.pinCode,
                                                    _model.reenterPin,
                                                    '8',
                                                    6);
                                            safeSetState(() {});
                                            _model.pinCode =
                                                functions.nextPinCode(
                                                    _model.pinCode, '8', 6);
                                            safeSetState(() {});
                                            if (_model.passcodeResult == 2) {
                                              _model.passcodeSetttmgmox4 =
                                                  await actions.haatSetPasscode(
                                                _model.createdPasscode,
                                              );
                                              if (_model.passcodeSetttmgmox4 ==
                                                  '') {
                                                context.pushNamed(
                                                    BiomatricPageWidget
                                                        .routeName);

                                                if (_model.passcodeResult ==
                                                    3) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Passcode does not match. Please try again.',
                                                        style: TextStyle(),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 4000),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      _model
                                                          .passcodeSetttmgmox4!,
                                                      style: TextStyle(),
                                                    ),
                                                    duration: Duration(
                                                        milliseconds: 4000),
                                                  ),
                                                );
                                                _model.pinCode = '';
                                                safeSetState(() {});
                                                _model.createdPasscode = '';
                                                safeSetState(() {});
                                                _model.reenterPin = false;
                                                safeSetState(() {});
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
                                                '8',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .montserrat(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
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
                                            _model.passcodeResult =
                                                functions.passcodeStepResult(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '9',
                                                    6);
                                            safeSetState(() {});
                                            _model.createdPasscode =
                                                functions.nextCreatedPasscode(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '9',
                                                    6);
                                            safeSetState(() {});
                                            _model.reenterPin =
                                                functions.nextReenterPin(
                                                    _model.pinCode,
                                                    _model.reenterPin,
                                                    '9',
                                                    6);
                                            safeSetState(() {});
                                            _model.pinCode =
                                                functions.nextPinCode(
                                                    _model.pinCode, '9', 6);
                                            safeSetState(() {});
                                            if (_model.passcodeResult == 2) {
                                              _model.passcodeSeteowv7u1j =
                                                  await actions.haatSetPasscode(
                                                _model.createdPasscode,
                                              );
                                              if (_model.passcodeSeteowv7u1j ==
                                                  '') {
                                                context.pushNamed(
                                                    BiomatricPageWidget
                                                        .routeName);

                                                if (_model.passcodeResult ==
                                                    3) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Passcode does not match. Please try again.',
                                                        style: TextStyle(),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 4000),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      _model
                                                          .passcodeSeteowv7u1j!,
                                                      style: TextStyle(),
                                                    ),
                                                    duration: Duration(
                                                        milliseconds: 4000),
                                                  ),
                                                );
                                                _model.pinCode = '';
                                                safeSetState(() {});
                                                _model.createdPasscode = '';
                                                safeSetState(() {});
                                                _model.reenterPin = false;
                                                safeSetState(() {});
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
                                                '9',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .montserrat(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
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
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.sizeOf(context).width *
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
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  _model.passcodeResult =
                                                      functions.passcodeStepResult(
                                                          _model.pinCode,
                                                          _model
                                                              .createdPasscode,
                                                          _model.reenterPin,
                                                          '0',
                                                          6);
                                                  safeSetState(() {});
                                                  _model.createdPasscode =
                                                      functions
                                                          .nextCreatedPasscode(
                                                              _model.pinCode,
                                                              _model
                                                                  .createdPasscode,
                                                              _model.reenterPin,
                                                              '0',
                                                              6);
                                                  safeSetState(() {});
                                                  _model.reenterPin =
                                                      functions.nextReenterPin(
                                                          _model.pinCode,
                                                          _model.reenterPin,
                                                          '0',
                                                          6);
                                                  safeSetState(() {});
                                                  _model.pinCode =
                                                      functions.nextPinCode(
                                                          _model.pinCode,
                                                          '0',
                                                          6);
                                                  safeSetState(() {});
                                                  if (_model.passcodeResult ==
                                                      2) {
                                                    _model.passcodeSetm6hat50e =
                                                        await actions
                                                            .haatSetPasscode(
                                                      _model.createdPasscode,
                                                    );
                                                    if (_model
                                                            .passcodeSetm6hat50e ==
                                                        '') {
                                                      context.pushNamed(
                                                          BiomatricPageWidget
                                                              .routeName);

                                                      if (_model
                                                              .passcodeResult ==
                                                          3) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              'Passcode does not match. Please try again.',
                                                              style:
                                                                  TextStyle(),
                                                            ),
                                                            duration: Duration(
                                                                milliseconds:
                                                                    4000),
                                                          ),
                                                        );
                                                      }
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            _model
                                                                .passcodeSetm6hat50e!,
                                                            style: TextStyle(),
                                                          ),
                                                          duration: Duration(
                                                              milliseconds:
                                                                  4000),
                                                        ),
                                                      );
                                                      _model.pinCode = '';
                                                      safeSetState(() {});
                                                      _model.createdPasscode =
                                                          '';
                                                      safeSetState(() {});
                                                      _model.reenterPin = false;
                                                      safeSetState(() {});
                                                    }
                                                  }

                                                  safeSetState(() {});
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(15.0, 0.0,
                                                                15.0, 0.0),
                                                    child: Text(
                                                      '0',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                font: GoogleFonts
                                                                    .montserrat(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                fontSize: 32.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontStyle: FlutterFlowTheme.of(
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
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  _model.pinCode = functions
                                                      .removeLastPinDigit(
                                                          _model.pinCode);
                                                  safeSetState(() {});
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(15.0, 0.0,
                                                                15.0, 0.0),
                                                    child: Icon(
                                                      Icons.backspace_outlined,
                                                      color:
                                                          FlutterFlowTheme.of(
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
                  ],
                ),
              );
            } else {
              return Container(
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
                        padding: EdgeInsetsDirectional.fromSTEB(
                            15.0, 0.0, 15.0, 0.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 67.0, 0.0, 0.0),
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        0.17,
                                                    height: 3.0,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2.0),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        0.17,
                                                    height: 3.0,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2.0),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        0.17,
                                                    height: 3.0,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2.0),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        0.17,
                                                    height: 3.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0x4CFFFFFF),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2.0),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: MediaQuery.sizeOf(
                                                                context)
                                                            .width *
                                                        0.17,
                                                    height: 3.0,
                                                    decoration: BoxDecoration(
                                                      color: Color(0x4DFFFFFF),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              2.0),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
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
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 19.0,
                                                                0.0, 0.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        InkWell(
                                                          splashColor: Colors
                                                              .transparent,
                                                          focusColor: Colors
                                                              .transparent,
                                                          hoverColor: Colors
                                                              .transparent,
                                                          highlightColor: Colors
                                                              .transparent,
                                                          onTap: () async {
                                                            _model.reenterPin =
                                                                false;
                                                            safeSetState(() {});
                                                            _model.pinCode = '';
                                                            safeSetState(() {});
                                                            _model.createdPasscode =
                                                                '';
                                                            safeSetState(() {});
                                                            _model.passcodeResult =
                                                                0;
                                                            safeSetState(() {});
                                                          },
                                                          child: Icon(
                                                            Icons.arrow_back,
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .primaryText,
                                                            size: 24.0,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 10.0,
                                                                0.0, 0.0),
                                                    child: Container(
                                                      decoration:
                                                          BoxDecoration(),
                                                      child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            'Re-enter your passcode',
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .montserrat(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  color: FlutterFlowTheme.of(
                                                                          context)
                                                                      .primaryText,
                                                                  fontSize:
                                                                      30.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                          ),
                                                        ].divide(SizedBox(
                                                            height: 9.0)),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 40.0, 0.0, 0.0),
                                            child: Container(
                                              width: MediaQuery.sizeOf(context)
                                                      .width *
                                                  0.8,
                                              height: 100.0,
                                              decoration: BoxDecoration(),
                                              alignment: AlignmentDirectional(
                                                  0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    width: 16.0,
                                                    height: 16.0,
                                                    decoration: BoxDecoration(
                                                      color: functions
                                                              .isPinDotFilled(
                                                                  _model
                                                                      .pinCode,
                                                                  0)
                                                          ? FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText
                                                          : Color(0x00000000),
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color:
                                                            Color(0xFFE7E7E7),
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 16.0,
                                                    height: 16.0,
                                                    decoration: BoxDecoration(
                                                      color: functions
                                                              .isPinDotFilled(
                                                                  _model
                                                                      .pinCode,
                                                                  1)
                                                          ? FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText
                                                          : Color(0x00000000),
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color:
                                                            Color(0xFFE7E7E7),
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 16.0,
                                                    height: 16.0,
                                                    decoration: BoxDecoration(
                                                      color: functions
                                                              .isPinDotFilled(
                                                                  _model
                                                                      .pinCode,
                                                                  2)
                                                          ? FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText
                                                          : Color(0x00000000),
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color:
                                                            Color(0xFFE7E7E7),
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 16.0,
                                                    height: 16.0,
                                                    decoration: BoxDecoration(
                                                      color: functions
                                                              .isPinDotFilled(
                                                                  _model
                                                                      .pinCode,
                                                                  3)
                                                          ? FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText
                                                          : Color(0x00000000),
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color:
                                                            Color(0xFFE7E7E7),
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 16.0,
                                                    height: 16.0,
                                                    decoration: BoxDecoration(
                                                      color: functions
                                                              .isPinDotFilled(
                                                                  _model
                                                                      .pinCode,
                                                                  4)
                                                          ? FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText
                                                          : Color(0x00000000),
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color:
                                                            Color(0xFFE7E7E7),
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 16.0,
                                                    height: 16.0,
                                                    decoration: BoxDecoration(
                                                      color: functions
                                                              .isPinDotFilled(
                                                                  _model
                                                                      .pinCode,
                                                                  5)
                                                          ? FlutterFlowTheme.of(
                                                                  context)
                                                              .primaryText
                                                          : Color(0x00000000),
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                        color:
                                                            Color(0xFFE7E7E7),
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
                                  ],
                                ),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                            _model.passcodeResult =
                                                functions.passcodeStepResult(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '1',
                                                    6);
                                            safeSetState(() {});
                                            _model.createdPasscode =
                                                functions.nextCreatedPasscode(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '1',
                                                    6);
                                            safeSetState(() {});
                                            _model.reenterPin =
                                                functions.nextReenterPin(
                                                    _model.pinCode,
                                                    _model.reenterPin,
                                                    '1',
                                                    6);
                                            safeSetState(() {});
                                            _model.pinCode =
                                                functions.nextPinCode(
                                                    _model.pinCode, '1', 6);
                                            safeSetState(() {});
                                            if (_model.passcodeResult == 2) {
                                              _model.passcodeSetm08zcyxp =
                                                  await actions.haatSetPasscode(
                                                _model.createdPasscode,
                                              );
                                              if (_model.passcodeSetm08zcyxp ==
                                                  '') {
                                                context.pushNamed(
                                                    BiomatricPageWidget
                                                        .routeName);

                                                if (_model.passcodeResult ==
                                                    3) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Passcode does not match. Please try again.',
                                                        style: TextStyle(),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 4000),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      _model
                                                          .passcodeSetm08zcyxp!,
                                                      style: TextStyle(),
                                                    ),
                                                    duration: Duration(
                                                        milliseconds: 4000),
                                                  ),
                                                );
                                                _model.pinCode = '';
                                                safeSetState(() {});
                                                _model.createdPasscode = '';
                                                safeSetState(() {});
                                                _model.reenterPin = false;
                                                safeSetState(() {});
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
                                                '1',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .montserrat(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
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
                                            _model.passcodeResult =
                                                functions.passcodeStepResult(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '2',
                                                    6);
                                            safeSetState(() {});
                                            _model.createdPasscode =
                                                functions.nextCreatedPasscode(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '2',
                                                    6);
                                            safeSetState(() {});
                                            _model.reenterPin =
                                                functions.nextReenterPin(
                                                    _model.pinCode,
                                                    _model.reenterPin,
                                                    '2',
                                                    6);
                                            safeSetState(() {});
                                            _model.pinCode =
                                                functions.nextPinCode(
                                                    _model.pinCode, '2', 6);
                                            safeSetState(() {});
                                            if (_model.passcodeResult == 2) {
                                              _model.passcodeSetpq7156x0 =
                                                  await actions.haatSetPasscode(
                                                _model.createdPasscode,
                                              );
                                              if (_model.passcodeSetpq7156x0 ==
                                                  '') {
                                                context.pushNamed(
                                                    BiomatricPageWidget
                                                        .routeName);

                                                if (_model.passcodeResult ==
                                                    3) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Passcode does not match. Please try again.',
                                                        style: TextStyle(),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 4000),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      _model
                                                          .passcodeSetpq7156x0!,
                                                      style: TextStyle(),
                                                    ),
                                                    duration: Duration(
                                                        milliseconds: 4000),
                                                  ),
                                                );
                                                _model.pinCode = '';
                                                safeSetState(() {});
                                                _model.createdPasscode = '';
                                                safeSetState(() {});
                                                _model.reenterPin = false;
                                                safeSetState(() {});
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
                                                '2',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .montserrat(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
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
                                            _model.passcodeResult =
                                                functions.passcodeStepResult(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '3',
                                                    6);
                                            safeSetState(() {});
                                            _model.createdPasscode =
                                                functions.nextCreatedPasscode(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '3',
                                                    6);
                                            safeSetState(() {});
                                            _model.reenterPin =
                                                functions.nextReenterPin(
                                                    _model.pinCode,
                                                    _model.reenterPin,
                                                    '3',
                                                    6);
                                            safeSetState(() {});
                                            _model.pinCode =
                                                functions.nextPinCode(
                                                    _model.pinCode, '3', 6);
                                            safeSetState(() {});
                                            if (_model.passcodeResult == 2) {
                                              _model.passcodeSetmkra9yy4 =
                                                  await actions.haatSetPasscode(
                                                _model.createdPasscode,
                                              );
                                              if (_model.passcodeSetmkra9yy4 ==
                                                  '') {
                                                context.pushNamed(
                                                    BiomatricPageWidget
                                                        .routeName);

                                                if (_model.passcodeResult ==
                                                    3) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Passcode does not match. Please try again.',
                                                        style: TextStyle(),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 4000),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      _model
                                                          .passcodeSetmkra9yy4!,
                                                      style: TextStyle(),
                                                    ),
                                                    duration: Duration(
                                                        milliseconds: 4000),
                                                  ),
                                                );
                                                _model.pinCode = '';
                                                safeSetState(() {});
                                                _model.createdPasscode = '';
                                                safeSetState(() {});
                                                _model.reenterPin = false;
                                                safeSetState(() {});
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
                                                '3',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .montserrat(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
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
                                            _model.passcodeResult =
                                                functions.passcodeStepResult(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '4',
                                                    6);
                                            safeSetState(() {});
                                            _model.createdPasscode =
                                                functions.nextCreatedPasscode(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '4',
                                                    6);
                                            safeSetState(() {});
                                            _model.reenterPin =
                                                functions.nextReenterPin(
                                                    _model.pinCode,
                                                    _model.reenterPin,
                                                    '4',
                                                    6);
                                            safeSetState(() {});
                                            _model.pinCode =
                                                functions.nextPinCode(
                                                    _model.pinCode, '4', 6);
                                            safeSetState(() {});
                                            if (_model.passcodeResult == 2) {
                                              _model.passcodeSetu52e5vjm =
                                                  await actions.haatSetPasscode(
                                                _model.createdPasscode,
                                              );
                                              if (_model.passcodeSetu52e5vjm ==
                                                  '') {
                                                context.pushNamed(
                                                    BiomatricPageWidget
                                                        .routeName);

                                                if (_model.passcodeResult ==
                                                    3) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Passcode does not match. Please try again.',
                                                        style: TextStyle(),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 4000),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      _model
                                                          .passcodeSetu52e5vjm!,
                                                      style: TextStyle(),
                                                    ),
                                                    duration: Duration(
                                                        milliseconds: 4000),
                                                  ),
                                                );
                                                _model.pinCode = '';
                                                safeSetState(() {});
                                                _model.createdPasscode = '';
                                                safeSetState(() {});
                                                _model.reenterPin = false;
                                                safeSetState(() {});
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
                                                '4',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .montserrat(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
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
                                            _model.passcodeResult =
                                                functions.passcodeStepResult(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '5',
                                                    6);
                                            safeSetState(() {});
                                            _model.createdPasscode =
                                                functions.nextCreatedPasscode(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '5',
                                                    6);
                                            safeSetState(() {});
                                            _model.reenterPin =
                                                functions.nextReenterPin(
                                                    _model.pinCode,
                                                    _model.reenterPin,
                                                    '5',
                                                    6);
                                            safeSetState(() {});
                                            _model.pinCode =
                                                functions.nextPinCode(
                                                    _model.pinCode, '5', 6);
                                            safeSetState(() {});
                                            if (_model.passcodeResult == 2) {
                                              _model.passcodeSetr1z0plpm =
                                                  await actions.haatSetPasscode(
                                                _model.createdPasscode,
                                              );
                                              if (_model.passcodeSetr1z0plpm ==
                                                  '') {
                                                context.pushNamed(
                                                    BiomatricPageWidget
                                                        .routeName);

                                                if (_model.passcodeResult ==
                                                    3) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Passcode does not match. Please try again.',
                                                        style: TextStyle(),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 4000),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      _model
                                                          .passcodeSetr1z0plpm!,
                                                      style: TextStyle(),
                                                    ),
                                                    duration: Duration(
                                                        milliseconds: 4000),
                                                  ),
                                                );
                                                _model.pinCode = '';
                                                safeSetState(() {});
                                                _model.createdPasscode = '';
                                                safeSetState(() {});
                                                _model.reenterPin = false;
                                                safeSetState(() {});
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
                                                '5',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .montserrat(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
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
                                            _model.passcodeResult =
                                                functions.passcodeStepResult(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '6',
                                                    6);
                                            safeSetState(() {});
                                            _model.createdPasscode =
                                                functions.nextCreatedPasscode(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '6',
                                                    6);
                                            safeSetState(() {});
                                            _model.reenterPin =
                                                functions.nextReenterPin(
                                                    _model.pinCode,
                                                    _model.reenterPin,
                                                    '6',
                                                    6);
                                            safeSetState(() {});
                                            _model.pinCode =
                                                functions.nextPinCode(
                                                    _model.pinCode, '6', 6);
                                            safeSetState(() {});
                                            if (_model.passcodeResult == 2) {
                                              _model.passcodeSetif8rcct6 =
                                                  await actions.haatSetPasscode(
                                                _model.createdPasscode,
                                              );
                                              if (_model.passcodeSetif8rcct6 ==
                                                  '') {
                                                context.pushNamed(
                                                    BiomatricPageWidget
                                                        .routeName);

                                                if (_model.passcodeResult ==
                                                    3) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Passcode does not match. Please try again.',
                                                        style: TextStyle(),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 4000),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      _model
                                                          .passcodeSetif8rcct6!,
                                                      style: TextStyle(),
                                                    ),
                                                    duration: Duration(
                                                        milliseconds: 4000),
                                                  ),
                                                );
                                                _model.pinCode = '';
                                                safeSetState(() {});
                                                _model.createdPasscode = '';
                                                safeSetState(() {});
                                                _model.reenterPin = false;
                                                safeSetState(() {});
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
                                                '6',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .montserrat(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
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
                                            _model.passcodeResult =
                                                functions.passcodeStepResult(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '7',
                                                    6);
                                            safeSetState(() {});
                                            _model.createdPasscode =
                                                functions.nextCreatedPasscode(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '7',
                                                    6);
                                            safeSetState(() {});
                                            _model.reenterPin =
                                                functions.nextReenterPin(
                                                    _model.pinCode,
                                                    _model.reenterPin,
                                                    '7',
                                                    6);
                                            safeSetState(() {});
                                            _model.pinCode =
                                                functions.nextPinCode(
                                                    _model.pinCode, '7', 6);
                                            safeSetState(() {});
                                            if (_model.passcodeResult == 2) {
                                              _model.passcodeSeta06tmpwq =
                                                  await actions.haatSetPasscode(
                                                _model.createdPasscode,
                                              );
                                              if (_model.passcodeSeta06tmpwq ==
                                                  '') {
                                                context.pushNamed(
                                                    BiomatricPageWidget
                                                        .routeName);

                                                if (_model.passcodeResult ==
                                                    3) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Passcode does not match. Please try again.',
                                                        style: TextStyle(),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 4000),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      _model
                                                          .passcodeSeta06tmpwq!,
                                                      style: TextStyle(),
                                                    ),
                                                    duration: Duration(
                                                        milliseconds: 4000),
                                                  ),
                                                );
                                                _model.pinCode = '';
                                                safeSetState(() {});
                                                _model.createdPasscode = '';
                                                safeSetState(() {});
                                                _model.reenterPin = false;
                                                safeSetState(() {});
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
                                                '7',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .montserrat(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
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
                                            _model.passcodeResult =
                                                functions.passcodeStepResult(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '8',
                                                    6);
                                            safeSetState(() {});
                                            _model.createdPasscode =
                                                functions.nextCreatedPasscode(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '8',
                                                    6);
                                            safeSetState(() {});
                                            _model.reenterPin =
                                                functions.nextReenterPin(
                                                    _model.pinCode,
                                                    _model.reenterPin,
                                                    '8',
                                                    6);
                                            safeSetState(() {});
                                            _model.pinCode =
                                                functions.nextPinCode(
                                                    _model.pinCode, '8', 6);
                                            safeSetState(() {});
                                            if (_model.passcodeResult == 2) {
                                              _model.passcodeSetal48ni25 =
                                                  await actions.haatSetPasscode(
                                                _model.createdPasscode,
                                              );
                                              if (_model.passcodeSetal48ni25 ==
                                                  '') {
                                                context.pushNamed(
                                                    BiomatricPageWidget
                                                        .routeName);

                                                if (_model.passcodeResult ==
                                                    3) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Passcode does not match. Please try again.',
                                                        style: TextStyle(),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 4000),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      _model
                                                          .passcodeSetal48ni25!,
                                                      style: TextStyle(),
                                                    ),
                                                    duration: Duration(
                                                        milliseconds: 4000),
                                                  ),
                                                );
                                                _model.pinCode = '';
                                                safeSetState(() {});
                                                _model.createdPasscode = '';
                                                safeSetState(() {});
                                                _model.reenterPin = false;
                                                safeSetState(() {});
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
                                                '8',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .montserrat(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
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
                                            _model.passcodeResult =
                                                functions.passcodeStepResult(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '9',
                                                    6);
                                            safeSetState(() {});
                                            _model.createdPasscode =
                                                functions.nextCreatedPasscode(
                                                    _model.pinCode,
                                                    _model.createdPasscode,
                                                    _model.reenterPin,
                                                    '9',
                                                    6);
                                            safeSetState(() {});
                                            _model.reenterPin =
                                                functions.nextReenterPin(
                                                    _model.pinCode,
                                                    _model.reenterPin,
                                                    '9',
                                                    6);
                                            safeSetState(() {});
                                            _model.pinCode =
                                                functions.nextPinCode(
                                                    _model.pinCode, '9', 6);
                                            safeSetState(() {});
                                            if (_model.passcodeResult == 2) {
                                              _model.passcodeSetcsbnm4x2 =
                                                  await actions.haatSetPasscode(
                                                _model.createdPasscode,
                                              );
                                              if (_model.passcodeSetcsbnm4x2 ==
                                                  '') {
                                                context.pushNamed(
                                                    BiomatricPageWidget
                                                        .routeName);

                                                if (_model.passcodeResult ==
                                                    3) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Passcode does not match. Please try again.',
                                                        style: TextStyle(),
                                                      ),
                                                      duration: Duration(
                                                          milliseconds: 4000),
                                                    ),
                                                  );
                                                }
                                              } else {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                      _model
                                                          .passcodeSetcsbnm4x2!,
                                                      style: TextStyle(),
                                                    ),
                                                    duration: Duration(
                                                        milliseconds: 4000),
                                                  ),
                                                );
                                                _model.pinCode = '';
                                                safeSetState(() {});
                                                _model.createdPasscode = '';
                                                safeSetState(() {});
                                                _model.reenterPin = false;
                                                safeSetState(() {});
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
                                                '9',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .montserrat(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
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
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Container(
                                          width:
                                              MediaQuery.sizeOf(context).width *
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
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  _model.passcodeResult =
                                                      functions.passcodeStepResult(
                                                          _model.pinCode,
                                                          _model
                                                              .createdPasscode,
                                                          _model.reenterPin,
                                                          '0',
                                                          6);
                                                  safeSetState(() {});
                                                  _model.createdPasscode =
                                                      functions
                                                          .nextCreatedPasscode(
                                                              _model.pinCode,
                                                              _model
                                                                  .createdPasscode,
                                                              _model.reenterPin,
                                                              '0',
                                                              6);
                                                  safeSetState(() {});
                                                  _model.reenterPin =
                                                      functions.nextReenterPin(
                                                          _model.pinCode,
                                                          _model.reenterPin,
                                                          '0',
                                                          6);
                                                  safeSetState(() {});
                                                  _model.pinCode =
                                                      functions.nextPinCode(
                                                          _model.pinCode,
                                                          '0',
                                                          6);
                                                  safeSetState(() {});
                                                  if (_model.passcodeResult ==
                                                      2) {
                                                    _model.passcodeSetnaz2lsui =
                                                        await actions
                                                            .haatSetPasscode(
                                                      _model.createdPasscode,
                                                    );
                                                    if (_model
                                                            .passcodeSetnaz2lsui ==
                                                        '') {
                                                      context.pushNamed(
                                                          BiomatricPageWidget
                                                              .routeName);

                                                      if (_model
                                                              .passcodeResult ==
                                                          3) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                            content: Text(
                                                              'Passcode does not match. Please try again.',
                                                              style:
                                                                  TextStyle(),
                                                            ),
                                                            duration: Duration(
                                                                milliseconds:
                                                                    4000),
                                                          ),
                                                        );
                                                      }
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            _model
                                                                .passcodeSetnaz2lsui!,
                                                            style: TextStyle(),
                                                          ),
                                                          duration: Duration(
                                                              milliseconds:
                                                                  4000),
                                                        ),
                                                      );
                                                      _model.pinCode = '';
                                                      safeSetState(() {});
                                                      _model.createdPasscode =
                                                          '';
                                                      safeSetState(() {});
                                                      _model.reenterPin = false;
                                                      safeSetState(() {});
                                                    }
                                                  }

                                                  safeSetState(() {});
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(15.0, 0.0,
                                                                15.0, 0.0),
                                                    child: Text(
                                                      '0',
                                                      style:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .override(
                                                                font: GoogleFonts
                                                                    .montserrat(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                fontSize: 32.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                fontStyle: FlutterFlowTheme.of(
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
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  _model.pinCode = functions
                                                      .removeLastPinDigit(
                                                          _model.pinCode);
                                                  safeSetState(() {});
                                                },
                                                child: Container(
                                                  decoration: BoxDecoration(),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(15.0, 0.0,
                                                                15.0, 0.0),
                                                    child: Icon(
                                                      Icons.backspace_outlined,
                                                      color:
                                                          FlutterFlowTheme.of(
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
                  ],
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
