import '/backend/api_requests/api_calls.dart';
import '/components/transactions/transactions_widget.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import '/flutter_flow/instant_timer.dart';
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
      _model.instantTimer = InstantTimer.periodic(
        duration: Duration(milliseconds: 15000),
        callback: (timer) async {
          _model.transactionsResult =
              await HaatAuthGroup.recentTransactionsCall.call(
            accessToken: _model.token,
            limit: 100,
          );

          if ((_model.transactionsResult?.succeeded ?? true)) {
            _model.transactionList = HaatAuthGroup.recentTransactionsCall
                .transactions(
                  (_model.transactionsResult?.jsonBody ?? ''),
                )!
                .toList()
                .cast<dynamic>();
            if (_model.transactionList.isNotEmpty) {
              _model.transactions = true;
            }
          }
          _model.transactionsLoaded = true;
          safeSetState(() {});
        },
        startImmediately: true,
      );
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
              Container(
                width: double.infinity,
                height: 0.0,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: Image.asset(
                      'assets/images/GrayPageBg.png',
                    ).image,
                  ),
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(15.0, 55.0, 15.0, 0.0),
                    child: Container(
                      width: double.infinity,
                      height: 40.0,
                      child: Stack(
                        children: [
                          Align(
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Text(
                              'All Transactions',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    fontSize: 15.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                36.0, 0.0, 0.0, 0.0),
                            child: Container(
                              width: double.infinity,
                              height: 40.0,
                              child: custom_widgets.TransactionSearchBar(
                                width: double.infinity,
                                height: 40.0,
                                hintText: 'Name, amount or reference',
                                iconColor: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                fillColor:
                                    FlutterFlowTheme.of(context).primaryText,
                                onChanged: (query) async {
                                  _model.searchQuery = query;
                                  safeSetState(() {});
                                },
                              ),
                            ),
                          ),
                          Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: InkWell(
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
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_model.transactions)
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(15.0, 18.0, 0.0, 0.0),
                      child: FlutterFlowChoiceChips(
                        options: [
                          ChipData('Last 20 transactions'),
                          ChipData('Last week'),
                          ChipData('Last 30 days'),
                          ChipData('Last 3 months')
                        ],
                        onChanged: (val) async {
                          safeSetState(
                              () => _model.choiceChipsValue = val?.firstOrNull);
                          _model.filterIndex = functions
                              .transactionFilterIndex(_model.choiceChipsValue);
                          safeSetState(() {});
                        },
                        selectedChipStyle: ChipStyle(
                          backgroundColor: Color(0xFF00DA76),
                          textStyle:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.w600,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    fontSize: 12.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                    lineHeight: 1.33,
                                  ),
                          iconColor:
                              FlutterFlowTheme.of(context).primaryBackground,
                          iconSize: 16.0,
                          labelPadding: EdgeInsetsDirectional.fromSTEB(
                              13.0, 6.0, 13.0, 6.0),
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        unselectedChipStyle: ChipStyle(
                          backgroundColor: Color(0xFFEBEBEB),
                          textStyle:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FontWeight.normal,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryBackground,
                                    fontSize: 12.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                    lineHeight: 1.33,
                                  ),
                          iconColor:
                              FlutterFlowTheme.of(context).primaryBackground,
                          iconSize: 16.0,
                          labelPadding: EdgeInsetsDirectional.fromSTEB(
                              13.0, 6.0, 13.0, 6.0),
                          elevation: 0.0,
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        chipSpacing: 6.0,
                        rowSpacing: 8.0,
                        multiselect: false,
                        initialized: _model.choiceChipsValue != null,
                        alignment: WrapAlignment.start,
                        controller: _model.choiceChipsValueController ??=
                            FormFieldController<List<String>>(
                          ['Last 20 transactions'],
                        ),
                        wrapped: false,
                      ),
                    ),
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Builder(
                              builder: (context) {
                                if (!_model.transactionsLoaded) {
                                  return Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 18.0, 0.0, 0.0),
                                    child: Center(
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
                                  );
                                } else if (_model.transactions == false) {
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
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    font:
                                                        GoogleFonts.montserrat(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryBackground,
                                                    fontSize: 24.0,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.bold,
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
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .bodyMedium
                                                  .override(
                                                    font:
                                                        GoogleFonts.montserrat(
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
                                                    color: Color(0xF1000000),
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
                                } else if (functions
                                    .transactionDayGroups(
                                        functions.filterTransactions(
                                            _model.transactionList.toList(),
                                            _model.searchQuery),
                                        _model.filterIndex)!
                                    .isEmpty) {
                                  return Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 90.0, 0.0, 0.0),
                                    child: Container(
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 56.0,
                                            height: 56.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              shape: BoxShape.circle,
                                            ),
                                            alignment:
                                                AlignmentDirectional(0.0, 0.0),
                                            child: Icon(
                                              Icons.search_off_rounded,
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryBackground,
                                              size: 24.0,
                                            ),
                                          ),
                                          Text(
                                            'Nothing found',
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
                                                .bodyMedium
                                                .override(
                                                  font: GoogleFonts.montserrat(
                                                    fontWeight: FontWeight.bold,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .bodyMedium
                                                            .fontStyle,
                                                  ),
                                                  color: FlutterFlowTheme.of(
                                                          context)
                                                      .primaryBackground,
                                                  fontSize: 17.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                          ),
                                          Text(
                                            'Try a name, an amount or a reference,\nor pick a longer period above.',
                                            textAlign: TextAlign.center,
                                            style: FlutterFlowTheme.of(context)
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
                                                  color: Color(0xC257636C),
                                                  fontSize: 13.0,
                                                  letterSpacing: 0.0,
                                                  fontWeight: FontWeight.normal,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                  lineHeight: 1.4,
                                                ),
                                          ),
                                        ].divide(SizedBox(height: 10.0)),
                                      ),
                                    ),
                                  );
                                } else {
                                  return Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0, 20.0, 0.0, 30.0),
                                    child: Builder(
                                      builder: (context) {
                                        final dayGroup = functions
                                                .transactionDayGroups(
                                                    functions
                                                        .filterTransactions(
                                                            _model
                                                                .transactionList
                                                                .toList(),
                                                            _model.searchQuery),
                                                    _model.filterIndex)
                                                ?.toList() ??
                                            [];

                                        return ListView.separated(
                                          padding: EdgeInsets.zero,
                                          primary: false,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          itemCount: dayGroup.length,
                                          separatorBuilder: (_, __) =>
                                              SizedBox(height: 18.0),
                                          itemBuilder:
                                              (context, dayGroupIndex) {
                                            final dayGroupItem =
                                                dayGroup[dayGroupIndex];
                                            return Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                          4.0, 0.0, 0.0, 0.0),
                                                  child: Text(
                                                    getJsonField(
                                                      dayGroupItem,
                                                      r'''$.label''',
                                                    ).toString(),
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font:
                                                              GoogleFonts.inter(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color:
                                                              Color(0x8A000000),
                                                          fontSize: 11.0,
                                                          letterSpacing: 0.4,
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
                                                Container(
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            16.0),
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(10.0, 6.0,
                                                                10.0, 6.0),
                                                    child: Builder(
                                                      builder: (context) {
                                                        final txItem =
                                                            getJsonField(
                                                                  dayGroupItem,
                                                                  r'''$.rows''',
                                                                  true,
                                                                )?.toList() ??
                                                                [];

                                                        return ListView.builder(
                                                          padding:
                                                              EdgeInsets.zero,
                                                          primary: false,
                                                          shrinkWrap: true,
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          itemCount:
                                                              txItem.length,
                                                          itemBuilder: (context,
                                                              txItemIndex) {
                                                            final txItemItem =
                                                                txItem[
                                                                    txItemIndex];
                                                            return TransactionsWidget(
                                                              key: Key(
                                                                  'Keyetz_${txItemIndex}_of_${txItem.length}'),
                                                              title: functions.transactionTitle(
                                                                  getJsonField(
                                                                    txItemItem,
                                                                    r'''$.description''',
                                                                  ).toString(),
                                                                  getJsonField(
                                                                    txItemItem,
                                                                    r'''$.kind''',
                                                                  ).toString()),
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
                                                                  ).toString()),
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
                                                              incoming: functions
                                                                  .transactionIsIncoming(
                                                                      getJsonField(
                                                                txItemItem,
                                                                r'''$.direction''',
                                                              ).toString()),
                                                              paymentMethod:
                                                                  getJsonField(
                                                                txItemItem,
                                                                r'''$.paymentMethod''',
                                                              ).toString(),
                                                              showDivider: functions
                                                                  .isNotLastItem(
                                                                      txItemIndex,
                                                                      txItem
                                                                          .length),
                                                            );
                                                          },
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
