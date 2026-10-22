import '/components/notification_action_row/notification_action_row_widget.dart';
import '/components/notification_item/notification_item_widget.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'notifications_model.dart';
export 'notifications_model.dart';

class NotificationsWidget extends StatefulWidget {
  const NotificationsWidget({super.key});

  static String routeName = 'Notifications';
  static String routePath = '/notifications';

  @override
  State<NotificationsWidget> createState() => _NotificationsWidgetState();
}

class _NotificationsWidgetState extends State<NotificationsWidget> {
  late NotificationsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificationsModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _model.loadNotifications(context);
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
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFF5F5F7),
        body: Stack(
          children: [
            Align(
              alignment: AlignmentDirectional(0.0, -1.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0.0),
                child: Image.asset(
                  'assets/images/GrayPageBg.png',
                  width: double.infinity,
                  height: 162.0,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Align(
              alignment: AlignmentDirectional(-1.0, -1.0),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0.0, 67.0, 0.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: (FFCrossAxisAlignment.start).flutterValue,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 0.0),
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
                              color: Colors.black,
                              size: 24.0,
                            ),
                          ),
                          Text(
                            'Notifications',
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color: Color(0xFF111111),
                                  fontSize: 15.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                  lineHeight: 1.47,
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
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 0.0, 0.0),
                      child: FlutterFlowChoiceChips(
                        options: [
                          ChipData('All'),
                          ChipData('Actions'),
                          ChipData('Offers'),
                          ChipData('Updates')
                        ],
                        onChanged: (val) => safeSetState(
                            () => _model.choiceChipsValue = val?.firstOrNull),
                        selectedChipStyle: ChipStyle(
                          backgroundColor: Color(0xFF00DA76),
                          textStyle:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: Colors.black,
                                    fontSize: 12.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                    lineHeight: 1.33,
                                  ),
                          iconColor: FlutterFlowTheme.of(context).info,
                          iconSize: 16.0,
                          labelPadding: EdgeInsetsDirectional.fromSTEB(
                              13.0, 5.0, 13.0, 5.0),
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        unselectedChipStyle: ChipStyle(
                          backgroundColor: Color(0xFFEBEBEB),
                          textStyle:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: Colors.black,
                                    fontSize: 12.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                    lineHeight: 1.33,
                                  ),
                          iconColor: FlutterFlowTheme.of(context).secondaryText,
                          iconSize: 16.0,
                          labelPadding: EdgeInsetsDirectional.fromSTEB(
                              13.0, 5.0, 13.0, 5.0),
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        chipSpacing: 4.0,
                        rowSpacing: 8.0,
                        multiselect: false,
                        initialized: _model.choiceChipsValue != null,
                        alignment: WrapAlignment.start,
                        controller: _model.choiceChipsValueController ??=
                            FormFieldController<List<String>>(
                          ['All'],
                        ),
                        wrapped: true,
                      ),
                    ),
                    Expanded(
                      child: RefreshIndicator(
                        color: Color(0xFF00DA76),
                        onRefresh: () async {
                          await _model.loadNotifications(context);
                          safeSetState(() {});
                        },
                        child: ListView(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 24.0, 16.0, 24.0),
                          scrollDirection: Axis.vertical,
                          children: [
                            if (_model.loaded && _model.failed)
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 72.0, 0.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 56.0,
                                      height: 56.0,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: Icon(
                                        Icons.cloud_off_rounded,
                                        color: Color(0x73000000),
                                        size: 24.0,
                                      ),
                                    ),
                                    Text(
                                      'Couldn\'t load your notifications',
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: Color(0xFF111111),
                                            fontSize: 15.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                            lineHeight: 1.47,
                                          ),
                                    ),
                                    Text(
                                      'Check your connection and try again.',
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: Color(0xFF484848),
                                            fontSize: 12.0,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                            lineHeight: 1.5,
                                          ),
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 8.0, 0.0, 0.0),
                                      child: FFButtonWidget(
                                        onPressed: () async {
                                          await _model
                                              .loadNotifications(context);
                                          safeSetState(() {});
                                        },
                                        text: 'Try again',
                                        options: FFButtonOptions(
                                          height: 36.0,
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  20.0, 0.0, 20.0, 0.0),
                                          iconPadding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 0.0, 0.0, 0.0),
                                          color: Color(0xFF00DA76),
                                          textStyle: FlutterFlowTheme.of(
                                                  context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color: Colors.black,
                                                fontSize: 13.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                          elevation: 0.0,
                                          borderRadius:
                                              BorderRadius.circular(20.0),
                                        ),
                                      ),
                                    ),
                                  ].divide(SizedBox(height: 8.0)),
                                ),
                              ),
                            if (functions
                                .notificationsFor(_model.pendingActions,
                                    _model.choiceChipsValue, 'actions')
                                .isNotEmpty)
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment:
                                    (FFCrossAxisAlignment.stretch).flutterValue,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    'PENDING ACTIONS · ${functions.notificationsFor(_model.pendingActions, _model.choiceChipsValue, 'actions').length.toString()}',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: Color(0x73000000),
                                          fontSize: 11.0,
                                          letterSpacing: 0.55,
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                          lineHeight: 1.45,
                                        ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 8.0, 0.0, 8.0),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: Builder(
                                        builder: (context) {
                                          final pendingAction = functions
                                              .notificationsFor(
                                                  _model.pendingActions,
                                                  _model.choiceChipsValue,
                                                  'actions')
                                              .toList();

                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: List.generate(
                                                pendingAction.length,
                                                (pendingActionIndex) {
                                              final pendingActionItem =
                                                  pendingAction[
                                                      pendingActionIndex];
                                              return NotificationActionRowWidget(
                                                key: Key(
                                                    'Keypa1_${pendingActionIndex}_of_${pendingAction.length}'),
                                                title:
                                                    functions.notificationText(
                                                        pendingActionItem,
                                                        'title',
                                                        FFAppState()
                                                            .languageCode),
                                                body:
                                                    functions.notificationText(
                                                        pendingActionItem,
                                                        'body',
                                                        FFAppState()
                                                            .languageCode),
                                                actionKey: getJsonField(
                                                  pendingActionItem,
                                                  r'''$.key''',
                                                )?.toString(),
                                                showDot: getJsonField(
                                                      pendingActionItem,
                                                      r'''$.key''',
                                                    )?.toString() !=
                                                    'add_team',
                                                showDivider:
                                                    functions.isNotLastItem(
                                                        pendingActionIndex,
                                                        pendingAction.length),
                                                onTap: () async {
                                                  if ((getJsonField(
                                                            pendingActionItem,
                                                            r'''$.key''',
                                                          )?.toString() ==
                                                          'verify_identity') ||
                                                      (getJsonField(
                                                            pendingActionItem,
                                                            r'''$.key''',
                                                          )?.toString() ==
                                                          'update_identity')) {
                                                    context.pushNamed(
                                                        VerifyPageWidget
                                                            .routeName);
                                                  } else if (getJsonField(
                                                        pendingActionItem,
                                                        r'''$.key''',
                                                      )?.toString() ==
                                                      'trade_licence') {
                                                    context.pushNamed(
                                                        UploadDocWidget
                                                            .routeName);
                                                  } else if (getJsonField(
                                                        pendingActionItem,
                                                        r'''$.key''',
                                                      )?.toString() ==
                                                      'add_team') {
                                                    context.pushNamed(
                                                        AddEmployeesWidget
                                                            .routeName);
                                                  }
                                                },
                                              );
                                            }),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (functions
                                .notificationsFor(_model.todayItems,
                                    _model.choiceChipsValue, 'today')
                                .isNotEmpty)
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment:
                                    (FFCrossAxisAlignment.stretch).flutterValue,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    'TODAY',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: Color(0x73000000),
                                          fontSize: 11.0,
                                          letterSpacing: 0.55,
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                          lineHeight: 1.45,
                                        ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 8.0, 0.0, 8.0),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: Builder(
                                        builder: (context) {
                                          final todayItem = functions
                                              .notificationsFor(
                                                  _model.todayItems,
                                                  _model.choiceChipsValue,
                                                  'today')
                                              .toList();

                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children:
                                                List.generate(todayItem.length,
                                                    (todayItemIndex) {
                                              final todayItemItem =
                                                  todayItem[todayItemIndex];
                                              return NotificationItemWidget(
                                                key: Key(
                                                    'Keynt1_${todayItemIndex}_of_${todayItem.length}'),
                                                title:
                                                    functions.notificationText(
                                                        todayItemItem,
                                                        'title',
                                                        FFAppState()
                                                            .languageCode),
                                                body:
                                                    functions.notificationText(
                                                        todayItemItem,
                                                        'body',
                                                        FFAppState()
                                                            .languageCode),
                                                time:
                                                    functions.notificationTime(
                                                        getJsonField(
                                                  todayItemItem,
                                                  r'''$.publishedAt''',
                                                )?.toString()),
                                                imageUrl:
                                                    functions.bannerImageUrl(
                                                        getJsonField(
                                                          todayItemItem,
                                                          r'''$.imagePath''',
                                                        )?.toString(),
                                                        FFDevEnvironmentValues()
                                                            .baseURL),
                                                category: getJsonField(
                                                  todayItemItem,
                                                  r'''$.category''',
                                                )?.toString(),
                                                unread: getJsonField(
                                                  todayItemItem,
                                                  r'''$.unread''',
                                                ),
                                                showDivider:
                                                    functions.isNotLastItem(
                                                        todayItemIndex,
                                                        todayItem.length),
                                                onTap: () async {
                                                  await actions.openBannerLink(
                                                    context,
                                                    getJsonField(
                                                      todayItemItem,
                                                      r'''$.linkUrl''',
                                                    )?.toString(),
                                                    null,
                                                  );
                                                },
                                              );
                                            }),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (functions
                                .notificationsFor(_model.earlierItems,
                                    _model.choiceChipsValue, 'earlier')
                                .isNotEmpty)
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment:
                                    (FFCrossAxisAlignment.stretch).flutterValue,
                                textBaseline: TextBaseline.alphabetic,
                                children: [
                                  Text(
                                    'EARLIER',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: Color(0x73000000),
                                          fontSize: 11.0,
                                          letterSpacing: 0.55,
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                          lineHeight: 1.45,
                                        ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 8.0, 0.0, 8.0),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(16.0),
                                      ),
                                      child: Builder(
                                        builder: (context) {
                                          final earlierItem = functions
                                              .notificationsFor(
                                                  _model.earlierItems,
                                                  _model.choiceChipsValue,
                                                  'earlier')
                                              .toList();

                                          return Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: List.generate(
                                                earlierItem.length,
                                                (earlierItemIndex) {
                                              final earlierItemItem =
                                                  earlierItem[earlierItemIndex];
                                              return NotificationItemWidget(
                                                key: Key(
                                                    'Keynt2_${earlierItemIndex}_of_${earlierItem.length}'),
                                                title:
                                                    functions.notificationText(
                                                        earlierItemItem,
                                                        'title',
                                                        FFAppState()
                                                            .languageCode),
                                                body:
                                                    functions.notificationText(
                                                        earlierItemItem,
                                                        'body',
                                                        FFAppState()
                                                            .languageCode),
                                                time:
                                                    functions.notificationTime(
                                                        getJsonField(
                                                  earlierItemItem,
                                                  r'''$.publishedAt''',
                                                )?.toString()),
                                                imageUrl:
                                                    functions.bannerImageUrl(
                                                        getJsonField(
                                                          earlierItemItem,
                                                          r'''$.imagePath''',
                                                        )?.toString(),
                                                        FFDevEnvironmentValues()
                                                            .baseURL),
                                                category: getJsonField(
                                                  earlierItemItem,
                                                  r'''$.category''',
                                                )?.toString(),
                                                unread: getJsonField(
                                                  earlierItemItem,
                                                  r'''$.unread''',
                                                ),
                                                showDivider:
                                                    functions.isNotLastItem(
                                                        earlierItemIndex,
                                                        earlierItem.length),
                                                onTap: () async {
                                                  await actions.openBannerLink(
                                                    context,
                                                    getJsonField(
                                                      earlierItemItem,
                                                      r'''$.linkUrl''',
                                                    )?.toString(),
                                                    null,
                                                  );
                                                },
                                              );
                                            }),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            if (_model.loaded &&
                                !_model.failed &&
                                functions
                                    .notificationsFor(_model.pendingActions,
                                        _model.choiceChipsValue, 'actions')
                                    .isEmpty &&
                                functions
                                    .notificationsFor(_model.todayItems,
                                        _model.choiceChipsValue, 'today')
                                    .isEmpty &&
                                functions
                                    .notificationsFor(_model.earlierItems,
                                        _model.choiceChipsValue, 'earlier')
                                    .isEmpty)
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 72.0, 0.0, 0.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(0.0),
                                      child: Image.asset(
                                        'assets/images/Illustration · bell 145 (content).png',
                                        width: 145.0,
                                        height: 145.0,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    Text(
                                      'You\'re all caught up',
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight: FontWeight.bold,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: Color(0xFF111111),
                                            fontSize: 15.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                            lineHeight: 1.47,
                                          ),
                                    ),
                                    Text(
                                      'Things to do, offers and updates will show up here.',
                                      textAlign: TextAlign.center,
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.inter(
                                              fontWeight:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontWeight,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: Color(0xFF484848),
                                            fontSize: 12.0,
                                            letterSpacing: 0.0,
                                            fontWeight:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontWeight,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                            lineHeight: 1.5,
                                          ),
                                    ),
                                  ].divide(SizedBox(height: 8.0)),
                                ),
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
      ),
    );
  }
}
