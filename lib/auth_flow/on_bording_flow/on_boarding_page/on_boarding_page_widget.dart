import '/auth_flow/on_bording_flow/on_boardin_components/first/first_widget.dart';
import '/auth_flow/on_bording_flow/on_boardin_components/second/second_widget.dart';
import '/auth_flow/on_bording_flow/on_boardin_components/third/third_widget.dart';
import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'on_boarding_page_model.dart';
export 'on_boarding_page_model.dart';

class OnBoardingPageWidget extends StatefulWidget {
  const OnBoardingPageWidget({super.key});

  static String routeName = 'OnBoardingPage';
  static String routePath = '/onBoardingPage';

  @override
  State<OnBoardingPageWidget> createState() => _OnBoardingPageWidgetState();
}

class _OnBoardingPageWidgetState extends State<OnBoardingPageWidget> {
  late OnBoardingPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OnBoardingPageModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (FFAppState().deviceFingerprint == '') {
        _model.generatedId = await actions.newUuid();
        FFAppState().deviceFingerprint = _model.generatedId!;
        safeSetState(() {});
      }
      if (FFAppState().refreshToken == '') {
        FFAppState().authStatus = 'signedOut';
        safeSetState(() {});
        if (FFAppState().hasLoggedInBefore == true) {
          context.pushNamed(LoginScreenWidget.routeName);
        }
      } else {
        _model.refreshResult = await HaatAuthGroup.refreshTokenCall.call(
          refreshToken: FFAppState().refreshToken,
          authToken: FFAppState().languageCode,
          baseURL: FFAppState().accessToken,
        );

        if ((_model.refreshResult?.succeeded ?? true)) {
          FFAppState().accessToken = getJsonField(
            (_model.refreshResult?.jsonBody ?? ''),
            r'''$.data.accessToken''',
          ).toString();
          FFAppState().refreshToken = getJsonField(
            (_model.refreshResult?.jsonBody ?? ''),
            r'''$.data.refreshToken''',
          ).toString();
          safeSetState(() {});
          _model.credResult = await HaatAuthGroup.credentialStatusCall.call(
            baseURL: FFAppState().accessToken,
            authToken: FFAppState().languageCode,
          );

          if ((_model.credResult?.succeeded ?? true)) {
            FFAppState().username = getJsonField(
              (_model.credResult?.jsonBody ?? ''),
              r'''$.data.username''',
            ).toString();
            FFAppState().hasPassword = getJsonField(
              (_model.credResult?.jsonBody ?? ''),
              r'''$.data.hasPassword''',
            );
            FFAppState().hasPasscode = getJsonField(
              (_model.credResult?.jsonBody ?? ''),
              r'''$.data.hasPasscode''',
            );
            FFAppState().mobileVerified = getJsonField(
              (_model.credResult?.jsonBody ?? ''),
              r'''$.data.mobileVerified''',
            );
            FFAppState().mfaEnabled = getJsonField(
              (_model.credResult?.jsonBody ?? ''),
              r'''$.data.mfaEnabled''',
            );
            FFAppState().mustChangePassword = getJsonField(
              (_model.credResult?.jsonBody ?? ''),
              r'''$.data.mustChangePassword''',
            );
            FFAppState().accountStatus = getJsonField(
              (_model.credResult?.jsonBody ?? ''),
              r'''$.data.status''',
            ).toString();
            safeSetState(() {});
            if (FFAppState().mustChangePassword == true) {
              FFAppState().authStatus = 'onboarding';
              safeSetState(() {});
              if (Navigator.of(context).canPop()) {
                context.pop();
              }
              context.pushNamed(CreatePasswordPageWidget.routeName);
            } else if (FFAppState().hasPassword == false) {
              FFAppState().authStatus = 'onboarding';
              safeSetState(() {});
              if (Navigator.of(context).canPop()) {
                context.pop();
              }
              context.pushNamed(CreatePasswordPageWidget.routeName);
            } else if (FFAppState().hasPasscode == false) {
              FFAppState().authStatus = 'onboarding';
              safeSetState(() {});
              if (Navigator.of(context).canPop()) {
                context.pop();
              }
              context.pushNamed(SecurePageWidget.routeName);
            } else if (FFAppState().username == '') {
              FFAppState().authStatus = 'onboarding';
              safeSetState(() {});
              if (Navigator.of(context).canPop()) {
                context.pop();
              }
              context.pushNamed(UsernamePageWidget.routeName);
            } else {
              FFAppState().authStatus = 'signedIn';
              safeSetState(() {});
              if (Navigator.of(context).canPop()) {
                context.pop();
              }
              context.pushNamed(BottomBarPagesWidget.routeName);
            }
          } else {
            FFAppState().authStatus = 'signedIn';
            safeSetState(() {});
            if (Navigator.of(context).canPop()) {
              context.pop();
            }
            context.pushNamed(BottomBarPagesWidget.routeName);
          }
        } else {
          if ((_model.refreshResult?.statusCode ?? 200) == -1) {
            FFAppState().authStatus = 'signedIn';
            safeSetState(() {});
            if (Navigator.of(context).canPop()) {
              context.pop();
            }
            context.pushNamed(BottomBarPagesWidget.routeName);
          } else {
            FFAppState().accessToken = '';
            FFAppState().refreshToken = '';
            FFAppState().userId = '';
            FFAppState().sessionId = '';
            FFAppState().deviceId = '';
            FFAppState().authStatus = 'signedOut';
            safeSetState(() {});
            if (Navigator.of(context).canPop()) {
              context.pop();
            }
            context.pushNamed(LoginScreenWidget.routeName);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

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
          decoration: BoxDecoration(),
          child: Align(
            alignment: AlignmentDirectional(0.0, 1.0),
            child: Stack(
              alignment: AlignmentDirectional(0.0, 1.0),
              children: [
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _model.onBoardingPageViewController ??=
                        PageController(initialPage: 0),
                    scrollDirection: Axis.horizontal,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: wrapWithModel(
                              model: _model.firstModel,
                              updateCallback: () => safeSetState(() {}),
                              child: FirstWidget(),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: wrapWithModel(
                              model: _model.secondModel,
                              updateCallback: () => safeSetState(() {}),
                              child: SecondWidget(),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: wrapWithModel(
                              model: _model.thirdModel,
                              updateCallback: () => safeSetState(() {}),
                              child: ThirdWidget(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 35.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      if (_model.onBoardingPageViewCurrentIndex == 2) {
                        context.pushNamed(OnBordingScreenWidget.routeName);
                      } else {
                        await _model.onBoardingPageViewController?.nextPage(
                          duration: Duration(milliseconds: 300),
                          curve: Curves.ease,
                        );
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 52.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).accent2,
                        borderRadius: BorderRadius.circular(106.67),
                        border: Border.all(
                          color: Color(0x44FFFFFF),
                          width: 1.0,
                        ),
                      ),
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Text(
                        'Next',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FontWeight.w500,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).primaryText,
                              fontSize: 18.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
