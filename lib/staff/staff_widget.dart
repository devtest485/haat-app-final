import '/backend/api_requests/api_calls.dart';
import '/components/empty_state/empty_state_widget.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'staff_model.dart';
export 'staff_model.dart';

class StaffWidget extends StatefulWidget {
  const StaffWidget({super.key});

  static String routeName = 'Staff';
  static String routePath = '/staff';

  @override
  State<StaffWidget> createState() => _StaffWidgetState();
}

class _StaffWidgetState extends State<StaffWidget> {
  late StaffModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => StaffModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _model.loadStaff(context);
      safeSetState(() {});
    });
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
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 86.0, 0.0, 0.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment:
                            (FFMainAxisAlignment.spaceBetween).flutterValue,
                        children: [
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              context.safePop();
                            },
                            child: Icon(
                              Icons.arrow_back,
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              size: 24.0,
                            ),
                          ),
                          Text(
                            'Staff',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  fontSize: 15.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                ),
                          ),
                          Container(
                            width: 24.0,
                            height: 24.0,
                            decoration: BoxDecoration(),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
                        child: Builder(
                          builder: (context) {
                            if (!_model.staffLoaded) {
                              return ListView(
                                padding: EdgeInsets.zero,
                                physics: const NeverScrollableScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 24.0, 0.0, 24.0),
                                      child: SizedBox(
                                        width: 32.0,
                                        height: 32.0,
                                        child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            FlutterFlowTheme.of(context)
                                                .tertiary,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            } else if (_model.loadError != '') {
                              return RefreshIndicator(
                                color: Color(0xFF00DA76),
                                onRefresh: () async {
                                  await _model.loadStaff(context);
                                  safeSetState(() {});
                                },
                                child: ListView(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      20.0, 40.0, 20.0, 0.0),
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  children: [
                                    Text(
                                      _model.loadError,
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.normal,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: Color(0xFF484848),
                                            fontSize: 13.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.normal,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                            lineHeight: 1.5,
                                          ),
                                    ),
                                  ],
                                ),
                              );
                            } else if (functions
                                    .staffSections(_model.staff.toList())
                                    .length ==
                                0) {
                              return Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 0.0, 0.0, 90.0),
                                child: wrapWithModel(
                                  model: _model.emptyStateModel,
                                  updateCallback: () => safeSetState(() {}),
                                  child: EmptyStateWidget(
                                    icon: Icon(
                                      Icons.group_outlined,
                                      color: Color(0xFF00A85B),
                                      size: 32.0,
                                    ),
                                    title: 'No staff yet',
                                    body:
                                        'Add the people who work with you. Each gets their own username and password, and shows up here.',
                                    buttonLabel: 'Add Employee',
                                    onPressed: () async {
                                      await context.pushNamed(
                                          AddEmpoleyNameWidget.routeName);

                                      await _model.loadStaff(context);
                                      safeSetState(() {});
                                    },
                                  ),
                                ),
                              );
                            } else {
                              return RefreshIndicator(
                                color: Color(0xFF00DA76),
                                onRefresh: () async {
                                  await _model.loadStaff(context);
                                  safeSetState(() {});
                                },
                                child: Builder(
                                  builder: (context) {
                                    final section = functions
                                        .staffSections(_model.staff.toList())
                                        .toList();

                                    return ListView.separated(
                                      padding:
                                          EdgeInsets.fromLTRB(0, 0, 0, 24.0),
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      scrollDirection: Axis.vertical,
                                      itemCount: section.length,
                                      separatorBuilder: (_, __) =>
                                          SizedBox(height: 20.0),
                                      itemBuilder: (context, sectionIndex) {
                                        final sectionItem =
                                            section[sectionIndex];
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          crossAxisAlignment:
                                              (FFCrossAxisAlignment.stretch)
                                                  .flutterValue,
                                          children: [
                                            Text(
                                              getJsonField(sectionItem,
                                                      r'''$.title''')
                                                  .toString(),
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    font: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                    color: Color(0x73000000),
                                                    fontSize: 11.0,
                                                    letterSpacing: 0.55,
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                    lineHeight: 1.45,
                                                  ),
                                            ),
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(16.0),
                                              ),
                                              child: Padding(
                                                padding: EdgeInsetsDirectional
                                                    .fromSTEB(
                                                        5.0, 0.0, 5.0, 0.0),
                                                child: Builder(
                                                  builder: (context) {
                                                    final member = getJsonField(
                                                            sectionItem,
                                                            r'''$.members''')
                                                        .toList();

                                                    return Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: List.generate(
                                                          member.length,
                                                          (memberIndex) {
                                                        final memberItem =
                                                            member[memberIndex];
                                                        return Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            InkWell(
                                                              splashColor: Colors
                                                                  .transparent,
                                                              focusColor: Colors
                                                                  .transparent,
                                                              hoverColor: Colors
                                                                  .transparent,
                                                              highlightColor:
                                                                  Colors
                                                                      .transparent,
                                                              onTap: () async {
                                                                await context
                                                                    .pushNamed(
                                                                  StaffMembersWidget
                                                                      .routeName,
                                                                  queryParameters:
                                                                      {
                                                                    'member':
                                                                        serializeParam(
                                                                      memberItem,
                                                                      ParamType
                                                                          .JSON,
                                                                    ),
                                                                  }.withoutNulls,
                                                                );

                                                                await _model
                                                                    .loadStaff(
                                                                        context);
                                                                safeSetState(
                                                                    () {});
                                                              },
                                                              child: Container(
                                                                height: 74.0,
                                                                decoration:
                                                                    BoxDecoration(),
                                                                child: Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          8.0,
                                                                          8.0,
                                                                          8.0,
                                                                          8.0),
                                                                  child: Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Container(
                                                                        width:
                                                                            32.0,
                                                                        height:
                                                                            32.0,
                                                                        decoration:
                                                                            BoxDecoration(
                                                                          color:
                                                                              FlutterFlowTheme.of(context).tertiary,
                                                                          shape:
                                                                              BoxShape.circle,
                                                                        ),
                                                                        alignment: AlignmentDirectional(
                                                                            0.0,
                                                                            0.0),
                                                                        child:
                                                                            Text(
                                                                          functions
                                                                              .staffInitials(getJsonField(memberItem, r'''$.fullName''').toString()),
                                                                          style: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .override(
                                                                                font: GoogleFonts.montserrat(
                                                                                  fontWeight: FontWeight.bold,
                                                                                  fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                ),
                                                                                color: FlutterFlowTheme.of(context).primaryBackground,
                                                                                fontSize: 12.0,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.bold,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                              ),
                                                                        ),
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          crossAxisAlignment:
                                                                              (FFCrossAxisAlignment.start).flutterValue,
                                                                          children:
                                                                              [
                                                                            Text(
                                                                              functions.staffDisplayName(memberItem),
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    font: GoogleFonts.montserrat(
                                                                                      fontWeight: FontWeight.bold,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                    ),
                                                                                    color: Color(0xFF111111),
                                                                                    fontSize: 13.0,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.bold,
                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                    lineHeight: 1.54,
                                                                                  ),
                                                                            ),
                                                                            Text(
                                                                              functions.staffSubtitle(memberItem),
                                                                              maxLines: 1,
                                                                              overflow: TextOverflow.ellipsis,
                                                                              style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                                                    font: GoogleFonts.inter(
                                                                                      fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                      fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                    ),
                                                                                    color: Color(0xFF484848),
                                                                                    fontSize: 12.0,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FlutterFlowTheme.of(context).bodyMedium.fontWeight,
                                                                                    fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                                    lineHeight: 1.5,
                                                                                  ),
                                                                            ),
                                                                          ].divide(SizedBox(height: 2.0)),
                                                                        ),
                                                                      ),
                                                                      Icon(
                                                                        Icons
                                                                            .chevron_right_rounded,
                                                                        color: Color(
                                                                            0x73000000),
                                                                        size:
                                                                            20.0,
                                                                      ),
                                                                    ].divide(SizedBox(
                                                                        width:
                                                                            12.0)),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            if (functions.isNotLastItem(
                                                                    memberIndex,
                                                                    member
                                                                        .length) ??
                                                                true)
                                                              Divider(
                                                                height: 1.0,
                                                                thickness: 1.0,
                                                                color: Color(
                                                                    0x14000000),
                                                              ),
                                                          ],
                                                        );
                                                      }),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ),
                                          ].divide(SizedBox(height: 8.0)),
                                        );
                                      },
                                    );
                                  },
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    if (_model.staffLoaded &&
                        (functions.staffSections(_model.staff.toList()).length >
                            0))
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                            15.0, 12.0, 15.0, 35.0),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            await context
                                .pushNamed(AddEmpoleyNameWidget.routeName);

                            await _model.loadStaff(context);
                            safeSetState(() {});
                          },
                          child: Container(
                            width: double.infinity,
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              borderRadius: BorderRadius.circular(106.67),
                            ),
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Text(
                              'Add Employee',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
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
            ],
          ),
        ),
      ),
    );
  }
}
