import '/backend/api_requests/api_calls.dart';
import '/components/transactions/transactions_widget.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'transactions_detials_model.dart';
export 'transactions_detials_model.dart';

class TransactionsDetialsWidget extends StatefulWidget {
  const TransactionsDetialsWidget({super.key});

  static String routeName = 'TransactionsDetials';
  static String routePath = '/transactionsDetials';

  @override
  State<TransactionsDetialsWidget> createState() =>
      _TransactionsDetialsWidgetState();
}

class _TransactionsDetialsWidgetState extends State<TransactionsDetialsWidget> {
  late TransactionsDetialsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TransactionsDetialsModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.traded = await actions.haatHasTransactions();
      _model.transactions = _model.traded!;
      safeSetState(() {});
      _model.token = await actions.haatAccessToken();
      await _loadTransactions();
    });
  }

  /// Fetches the rows for the selected chip, showing the shimmer meanwhile.
  Future<void> _loadTransactions() async {
    final request = ++_model.transactionsRequest;
    safeSetState(() => _model.transactionsLoaded = false);

    // A fast answer would otherwise flash the shimmer for a frame or two, which
    // reads as a flicker rather than as loading.
    final results = await Future.wait([
      HaatAuthGroup.recentTransactionsCall.call(
        accessToken: _model.token,
        limit: 100,
        since: functions.transactionSince(_model.filterIndex),
      ),
      Future.delayed(const Duration(milliseconds: 450)),
    ]);
    final result = results.first as ApiCallResponse;

    // The user has picked another chip since; that fetch owns the list now.
    if (request != _model.transactionsRequest) return;

    _model.transactionsResult = result;
    safeSetState(() {
      if (result.succeeded) {
        _model.transactionList = (HaatAuthGroup.recentTransactionsCall
                    .transactions(result.jsonBody ?? '') ??
                [])
            .toList()
            .cast<dynamic>();
      }
      _model.transactionsLoaded = true;
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        decoration: BoxDecoration(),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 55.0, 0.0, 0.0),
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
                                      'All Transactions',
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .override(
                                            font: GoogleFonts.montserrat(
                                              fontWeight: FontWeight.w500,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            fontSize: 15.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                    Icon(
                                      Icons.search_sharp,
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      size: 24.0,
                                    ),
                                  ],
                                ),
                              ),
                              Builder(
                                builder: (context) {
                                  if (_model.transactions == false) {
                                    return Visibility(
                                      visible: !FFAppState().hasTransactions,
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0.0, 140.0, 0.0, 0.0),
                                        child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(0.0),
                                                child: Image.asset(
                                                  'assets/images/Coin.png',
                                                  width: 165.0,
                                                  height: 165.0,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              Text(
                                                'No Transactions',
                                                textAlign: TextAlign.center,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .montserrat(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                          fontSize: 24.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                              ),
                                              Text(
                                                'Payments will show here as soon as your \nfirst one comes in.',
                                                textAlign: TextAlign.center,
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .montserrat(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color:
                                                              Color(0xF1000000),
                                                          fontSize: 13.0,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                          lineHeight: 1.4,
                                                        ),
                                              ),
                                            ].divide(SizedBox(height: 12.0)),
                                          ),
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 10.0, 0.0, 35.0),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 15.0, 0.0, 0.0),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Expanded(
                                                    child:
                                                        FlutterFlowChoiceChips(
                                                      options: [
                                                        ChipData(
                                                            'All transactions'),
                                                        ChipData(
                                                            'Last 20 transactions'),
                                                        ChipData('Last week'),
                                                        ChipData(
                                                            'Last 30 days'),
                                                        ChipData(
                                                            'Last 3 months')
                                                      ],
                                                      onChanged: (val) async {
                                                        final filter = functions
                                                            .transactionFilterIndex(
                                                                val?.firstOrNull);
                                                        // The chips report their initial selection
                                                        // on first build, and a tap on the chip
                                                        // already selected changes nothing.
                                                        if (filter ==
                                                                _model
                                                                    .filterIndex &&
                                                            _model.transactionsRequest >
                                                                0) {
                                                          return;
                                                        }
                                                        _model.choiceChipsValue =
                                                            val?.firstOrNull;
                                                        _model.filterIndex =
                                                            filter;
                                                        // Before the page load has the token, its
                                                        // own fetch picks up this filter.
                                                        if (_model.token ==
                                                            null) {
                                                          safeSetState(() {});
                                                          return;
                                                        }
                                                        await _loadTransactions();
                                                      },
                                                      selectedChipStyle:
                                                          ChipStyle(
                                                        backgroundColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .tertiary,
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
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
                                                                      .primaryBackground,
                                                                  fontSize:
                                                                      14.0,
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
                                                        iconColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .info,
                                                        iconSize: 20.0,
                                                        labelPadding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    12.0,
                                                                    8.0,
                                                                    12.0,
                                                                    8.0),
                                                        elevation: 0.0,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30.0),
                                                      ),
                                                      unselectedChipStyle:
                                                          ChipStyle(
                                                        backgroundColor:
                                                            Color(0xFFEBEBEB),
                                                        textStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .override(
                                                                  font:
                                                                      GoogleFonts
                                                                          .inter(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                                  color: Color(
                                                                      0xFF111111),
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
                                                        iconColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .secondaryText,
                                                        iconSize: 16.0,
                                                        labelPadding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    12.0,
                                                                    8.0,
                                                                    12.0,
                                                                    8.0),
                                                        elevation: 0.0,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30.0),
                                                      ),
                                                      chipSpacing: 8.0,
                                                      rowSpacing: 8.0,
                                                      multiselect: false,
                                                      initialized: _model
                                                              .choiceChipsValue !=
                                                          null,
                                                      alignment:
                                                          WrapAlignment.start,
                                                      controller: _model
                                                              .choiceChipsValueController ??=
                                                          FormFieldController<
                                                              List<String>>(
                                                        ['All transactions'],
                                                      ),
                                                      wrapped: false,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsetsDirectional
                                                  .fromSTEB(
                                                      0.0, 25.0, 0.0, 40.0),
                                              child: Builder(
                                                builder: (context) {
                                                  if (!_model
                                                      .transactionsLoaded) {
                                                    return custom_widgets
                                                        .TransactionsShimmer();
                                                  }
                                                  final dayGroup = functions
                                                          .transactionDayGroups(
                                                              _model
                                                                  .transactionList
                                                                  .toList(),
                                                              _model
                                                                  .filterIndex)
                                                          ?.toList() ??
                                                      [];

                                                  return ListView.separated(
                                                    padding: EdgeInsets.zero,
                                                    primary: false,
                                                    shrinkWrap: true,
                                                    scrollDirection:
                                                        Axis.vertical,
                                                    itemCount: dayGroup.length,
                                                    separatorBuilder: (_, __) =>
                                                        SizedBox(height: 20.0),
                                                    itemBuilder: (context,
                                                        dayGroupIndex) {
                                                      final dayGroupItem =
                                                          dayGroup[
                                                              dayGroupIndex];
                                                      return Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        crossAxisAlignment:
                                                            (FFCrossAxisAlignment
                                                                    .start)
                                                                .flutterValue,
                                                        textBaseline:
                                                            TextBaseline
                                                                .alphabetic,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                EdgeInsetsDirectional
                                                                    .fromSTEB(
                                                                        4.0,
                                                                        0.0,
                                                                        0.0,
                                                                        0.0),
                                                            child: Text(
                                                              getJsonField(
                                                                dayGroupItem,
                                                                r'''$.label''',
                                                              ).toString(),
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
                                                                    color: Color(
                                                                        0x8A000000),
                                                                    fontSize:
                                                                        11.0,
                                                                    letterSpacing:
                                                                        0.6,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontStyle: FlutterFlowTheme.of(
                                                                            context)
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                                  ),
                                                            ),
                                                          ),
                                                          Container(
                                                            decoration:
                                                                BoxDecoration(
                                                              color: FlutterFlowTheme
                                                                      .of(context)
                                                                  .primaryText,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          16.0),
                                                            ),
                                                            child: Column(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Builder(
                                                                  builder:
                                                                      (context) {
                                                                    final txItem =
                                                                        getJsonField(
                                                                      dayGroupItem,
                                                                      r'''$.rows''',
                                                                    ).toList();

                                                                    return ListView
                                                                        .builder(
                                                                      padding:
                                                                          EdgeInsets
                                                                              .zero,
                                                                      primary:
                                                                          false,
                                                                      shrinkWrap:
                                                                          true,
                                                                      scrollDirection:
                                                                          Axis.vertical,
                                                                      itemCount:
                                                                          txItem
                                                                              .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              txItemIndex) {
                                                                        final txItemItem =
                                                                            txItem[txItemIndex];
                                                                        return Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primaryText,
                                                                            borderRadius:
                                                                                BorderRadius.circular(16.0),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                5.0,
                                                                                0.0,
                                                                                5.0,
                                                                                0.0),
                                                                            child:
                                                                                TransactionsWidget(
                                                                              key: Key('Keyetz_${txItemIndex}_of_${txItem.length}'),
                                                                              title: functions.transactionTitle(
                                                                                  getJsonField(
                                                                                    txItemItem,
                                                                                    r'''$.description''',
                                                                                  ).toString(),
                                                                                  getJsonField(
                                                                                    txItemItem,
                                                                                    r'''$.kind''',
                                                                                  ).toString(),
                                                                                  getJsonField(txItemItem, r'''$.direction''').toString(),
                                                                                  getJsonField(txItemItem, r'''$.transfer''')),
                                                                              subtitle: functions.transactionSubtitle(
                                                                                  getJsonField(
                                                                                    txItemItem,
                                                                                    r'''$.description''',
                                                                                  ).toString(),
                                                                                  getJsonField(
                                                                                    txItemItem,
                                                                                    r'''$.kind''',
                                                                                  ).toString(),
                                                                                  getJsonField(
                                                                                    txItemItem,
                                                                                    r'''$.occurredAt''',
                                                                                  ).toString(),
                                                                                  getJsonField(txItemItem, r'''$.direction''').toString()),
                                                                              amount: functions.transactionAmount(
                                                                                  getJsonField(
                                                                                    txItemItem,
                                                                                    r'''$.amountMinor''',
                                                                                  ).toString(),
                                                                                  getJsonField(
                                                                                    txItemItem,
                                                                                    r'''$.currency''',
                                                                                  ).toString(),
                                                                                  getJsonField(
                                                                                    txItemItem,
                                                                                    r'''$.direction''',
                                                                                  ).toString()),
                                                                              incoming: functions.transactionIsIncoming(getJsonField(
                                                                                txItemItem,
                                                                                r'''$.direction''',
                                                                              ).toString()),
                                                                              paymentMethod: getJsonField(
                                                                                txItemItem,
                                                                                r'''$.paymentMethod''',
                                                                              ).toString(),
                                                                              tone: functions.transactionTone(getJsonField(txItemItem, r'''$.kind''').toString(), getJsonField(txItemItem, r'''$.direction''').toString()),
                                                                              showDivider: functions.groupPairDivider(dayGroupItem, txItemIndex),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      },
                                                                    );
                                                                  },
                                                                ),
                                                              ].divide(SizedBox(
                                                                  height: 7.0)),
                                                            ),
                                                          ),
                                                        ].divide(SizedBox(
                                                            height: 8.0)),
                                                      );
                                                    },
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                },
                              ),
                            ],
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
