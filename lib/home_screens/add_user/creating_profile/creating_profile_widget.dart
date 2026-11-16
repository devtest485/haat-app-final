import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'creating_profile_model.dart';
export 'creating_profile_model.dart';

class CreatingProfileWidget extends StatefulWidget {
  const CreatingProfileWidget({
    super.key,
    this.fullName,
    this.roleId,
    this.roleName,
    this.branchId,
    this.branchName,
  });

  final String? fullName;
  final String? roleId;
  final String? roleName;
  final String? branchId;
  final String? branchName;

  static String routeName = 'CreatingProfile';
  static String routePath = '/creatingProfile';

  @override
  State<CreatingProfileWidget> createState() => _CreatingProfileWidgetState();
}

class _CreatingProfileWidgetState extends State<CreatingProfileWidget>
    with TickerProviderStateMixin {
  late CreatingProfileModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final animationsMap = <String, AnimationInfo>{};

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreatingProfileModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.token = await actions.haatAccessToken();
      _model.attempt = 0;
      while (_model.attempt < 4) {
        _model.createResult = await HaatAuthGroup.createStaffCall.call(
          fullName: widget!.fullName,
          username: functions.staffUsername(widget!.fullName, _model.attempt),
          branchId: widget!.branchId,
          roleId: widget!.roleId,
          accessToken: _model.token,
        );

        if ((_model.createResult?.succeeded ?? true)) {
          _model.attempt = 99;
          safeSetState(() {});
        } else {
          if (functions.notificationText(
                  HaatAuthGroup.createStaffCall.staff(
                    (_model.createResult?.jsonBody ?? ''),
                  ),
                  'field',
                  '') ==
              'username') {
            _model.attempt = _model.attempt + 1;
            safeSetState(() {});
          } else {
            _model.attempt = 99;
            safeSetState(() {});
          }
        }
      }
      if ((_model.createResult?.succeeded ?? true)) {
        if (Navigator.of(context).canPop()) {
          context.pop();
        }
        context.pushNamed(
          EmployeDetailsWidget.routeName,
          queryParameters: {
            'staff': serializeParam(
              HaatAuthGroup.createStaffCall.staff(
                (_model.createResult?.jsonBody ?? ''),
              ),
              ParamType.JSON,
            ),
          }.withoutNulls,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              valueOrDefault<String>(
                functions.notificationText(
                    (_model.createResult?.jsonBody ?? ''), 'message', ''),
                'The employee could not be added. Try again.',
              ),
              style: TextStyle(
                color: FlutterFlowTheme.of(context).primaryText,
              ),
            ),
            duration: Duration(milliseconds: 4000),
            backgroundColor: FlutterFlowTheme.of(context).secondary,
          ),
        );
        context.safePop();
      }
    });

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ScaleEffect(
            curve: Curves.easeOut,
            delay: 0.0.ms,
            duration: 420.0.ms,
            begin: Offset(0.8, 0.8),
            end: Offset(1.0, 1.0),
          ),
          FadeEffect(
            curve: Curves.easeOut,
            delay: 0.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
        ],
      ),
    });
    setupAnimations(
      animationsMap.values.where((anim) =>
          anim.trigger == AnimationTrigger.onActionTrigger ||
          !anim.applyInitialState),
      this,
    );
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
            color: FlutterFlowTheme.of(context).secondaryBackground,
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
                          'assets/images/GrayPageBg.png',
                        ).image,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 320.0,
                      height: 320.0,
                      decoration: BoxDecoration(),
                      child: Container(
                        width: 320.0,
                        height: 320.0,
                        child: custom_widgets.StaffCreatingPulse(
                          width: 320.0,
                          height: 320.0,
                          initials: functions.staffInitials(widget!.fullName),
                        ),
                      ).animateOnPageLoad(
                          animationsMap['containerOnPageLoadAnimation']!),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(15.0, 15.0, 15.0, 0.0),
                      child: Text(
                        'Creating user Profile, We are generating username and password...',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w500,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                              lineHeight: 1.4,
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
