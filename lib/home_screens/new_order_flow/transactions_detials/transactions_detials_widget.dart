import '/backend/api_requests/api_calls.dart';
import '/components/transaction_filter_sheet/transaction_filter_sheet_widget.dart';
import '/components/transaction_shimmer_widget.dart';
import '/components/transactions/transactions_widget.dart';
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
        _model.transactionsLoaded = true;
        safeSetState(() {});
      } else {
        _model.transactionsLoaded = true;
        safeSetState(() {});
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
                                  children: [
                                    Expanded(
                                      child: Align(
                                        alignment:
                                            AlignmentDirectional(-1.0, 0.0),
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
                                    Expanded(
                                      child: Row(
                                        mainAxisSize: MainAxisSize.max,
                                        mainAxisAlignment:
                                            (FFMainAxisAlignment.end)
                                                .flutterValue,
                                        children: [
                                          Icon(
                                            Icons.search_sharp,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            size: 24.0,
                                          ),
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              await showModalBottomSheet(
                                                isScrollControlled: true,
                                                backgroundColor:
                                                    Colors.transparent,
                                                context: context,
                                                builder: (context) {
                                                  return GestureDetector(
                                                    onTap: () {
                                                      FocusScope.of(context)
                                                          .unfocus();
                                                      FocusManager
                                                          .instance.primaryFocus
                                                          ?.unfocus();
                                                    },
                                                    child: Padding(
                                                      padding: MediaQuery
                                                          .viewInsetsOf(
                                                              context),
                                                      child:
                                                          TransactionFilterSheetWidget(
                                                        transactions: _model
                                                            .transactionList,
                                                        filterIndex:
                                                            _model.filterIndex,
                                                        direction: _model
                                                            .directionFilter,
                                                        status:
                                                            _model.statusFilter,
                                                        method:
                                                            _model.methodFilter,
                                                        onApply: (direction,
                                                            status,
                                                            method) async {
                                                          _model.directionFilter =
                                                              direction;
                                                          _model.statusFilter =
                                                              status;
                                                          _model.methodFilter =
                                                              method;
                                                          safeSetState(() {});
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ).then((value) =>
                                                  safeSetState(() {}));
                                            },
                                            child: Container(
                                              width: 30.0,
                                              height: 30.0,
                                              child: Stack(
                                                children: [
                                                  Align(
                                                    alignment:
                                                        AlignmentDirectional(
                                                            0.0, 0.0),
                                                    child: Icon(
                                                      Icons.tune_rounded,
                                                      color: FlutterFlowTheme
                                                              .of(context)
                                                          .primaryBackground,
                                                      size: 24.0,
                                                    ),
                                                  ),
                                                  if (functions.activeTransactionFilters(
                                                          _model
                                                              .directionFilter,
                                                          _model.statusFilter,
                                                          _model.methodFilter) >
                                                      0)
                                                    Align(
                                                      alignment:
                                                          AlignmentDirectional(
                                                              1.0, -1.0),
                                                      child: Container(
                                                        width: 15.0,
                                                        height: 15.0,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .tertiary,
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            color: FlutterFlowTheme
                                                                    .of(context)
                                                                .secondaryBackground,
                                                            width: 1.5,
                                                          ),
                                                        ),
                                                        alignment:
                                                            AlignmentDirectional(
                                                                0.0, 0.0),
                                                        child: Text(
                                                          functions
                                                              .activeTransactionFilters(
                                                                  _model
                                                                      .directionFilter,
                                                                  _model
                                                                      .statusFilter,
                                                                  _model
                                                                      .methodFilter)
                                                              .toString(),
                                                          style: FlutterFlowTheme
                                                                  .of(context)
                                                              .bodyMedium
                                                              .override(
                                                                font: GoogleFonts
                                                                    .montserrat(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontStyle: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryBackground,
                                                                fontSize: 8.0,
                                                                letterSpacing:
                                                                    0.0,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontStyle: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                              ),
                                                        ),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ].divide(SizedBox(width: 14.0)),
                                      ),
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
                                                            'Last 20 transactions'),
                                                        ChipData('Last week'),
                                                        ChipData(
                                                            'Last 30 days'),
                                                        ChipData(
                                                            'Last 3 months')
                                                      ],
                                                      onChanged: (val) async {
                                                        safeSetState(() => _model
                                                                .choiceChipsValue =
                                                            val?.firstOrNull);
                                                        _model.filterIndex = functions
                                                            .transactionFilterIndex(
                                                                _model
                                                                    .choiceChipsValue);
                                                        _model.transactionsLoaded =
                                                            false;
                                                        safeSetState(() {});
                                                        _model.filterToken =
                                                            await actions
                                                                .haatAccessToken();
                                                        _model.filteredResult =
                                                            await HaatAuthGroup
                                                                .recentTransactionsCall
                                                                .call(
                                                          accessToken: _model
                                                              .filterToken,
                                                          limit: 100,
                                                          since: functions
                                                              .transactionSince(
                                                                  _model
                                                                      .filterIndex),
                                                        );

                                                        if ((_model
                                                                .filteredResult
                                                                ?.succeeded ??
                                                            true)) {
                                                          _model.transactionList =
                                                              HaatAuthGroup
                                                                  .recentTransactionsCall
                                                                  .transactions(
                                                                    (_model.filteredResult
                                                                            ?.jsonBody ??
                                                                        ''),
                                                                  )!
                                                                  .toList()
                                                                  .cast<
                                                                      dynamic>();
                                                          _model.transactionsLoaded =
                                                              true;
                                                          safeSetState(() {});
                                                        } else {
                                                          _model.transactionsLoaded =
                                                              true;
                                                          safeSetState(() {});
                                                        }

                                                        safeSetState(() {});
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
                                                                      .primaryBackground,
                                                                  fontSize:
                                                                      12.0,
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
                                                                    10.0,
                                                                    5.5,
                                                                    10.0,
                                                                    5.5),
                                                        elevation: 0.0,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    999.0),
                                                      ),
                                                      unselectedChipStyle:
                                                          ChipStyle(
                                                        backgroundColor:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .primaryText,
                                                        textStyle:
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
                                                                  color: Color(
                                                                      0xFF111111),
                                                                  fontSize:
                                                                      12.0,
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
                                                                    10.0,
                                                                    5.5,
                                                                    10.0,
                                                                    5.5),
                                                        elevation: 0.0,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    999.0),
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
                                                        [
                                                          'Last 20 transactions'
                                                        ],
                                                      ),
                                                      wrapped: false,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Builder(
                                              builder: (context) {
                                                if (_model.transactionsLoaded ==
                                                    false) {
                                                  return Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 25.0,
                                                                0.0, 40.0),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: [
                                                        Column(
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
                                                              child: Container(
                                                                width: 72.0,
                                                                height: 10.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Color(
                                                                      0xFFE6E6E6),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            5.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            5.0),
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            5.0),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            5.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16.0),
                                                              ),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            5.0,
                                                                            0.0,
                                                                            5.0,
                                                                            0.0),
                                                                    child:
                                                                        wrapWithModel(
                                                                      model: _model
                                                                          .transactionShimmerModel1,
                                                                      updateCallback:
                                                                          () =>
                                                                              safeSetState(() {}),
                                                                      child:
                                                                          TransactionShimmerWidget(
                                                                        index:
                                                                            0,
                                                                        showDivider:
                                                                            true,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            5.0,
                                                                            0.0,
                                                                            5.0,
                                                                            0.0),
                                                                    child:
                                                                        wrapWithModel(
                                                                      model: _model
                                                                          .transactionShimmerModel2,
                                                                      updateCallback:
                                                                          () =>
                                                                              safeSetState(() {}),
                                                                      child:
                                                                          TransactionShimmerWidget(
                                                                        index:
                                                                            1,
                                                                        showDivider:
                                                                            false,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ].divide(SizedBox(
                                                              height: 8.0)),
                                                        ),
                                                        Column(
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
                                                              child: Container(
                                                                width: 72.0,
                                                                height: 10.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Color(
                                                                      0xFFE6E6E6),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            5.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            5.0),
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            5.0),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            5.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16.0),
                                                              ),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            5.0,
                                                                            0.0,
                                                                            5.0,
                                                                            0.0),
                                                                    child:
                                                                        wrapWithModel(
                                                                      model: _model
                                                                          .transactionShimmerModel3,
                                                                      updateCallback:
                                                                          () =>
                                                                              safeSetState(() {}),
                                                                      child:
                                                                          TransactionShimmerWidget(
                                                                        index:
                                                                            0,
                                                                        showDivider:
                                                                            true,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            5.0,
                                                                            0.0,
                                                                            5.0,
                                                                            0.0),
                                                                    child:
                                                                        wrapWithModel(
                                                                      model: _model
                                                                          .transactionShimmerModel4,
                                                                      updateCallback:
                                                                          () =>
                                                                              safeSetState(() {}),
                                                                      child:
                                                                          TransactionShimmerWidget(
                                                                        index:
                                                                            1,
                                                                        showDivider:
                                                                            false,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ].divide(SizedBox(
                                                              height: 8.0)),
                                                        ),
                                                        Column(
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
                                                              child: Container(
                                                                width: 72.0,
                                                                height: 10.0,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Color(
                                                                      0xFFE6E6E6),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                            5.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            5.0),
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            5.0),
                                                                    bottomRight:
                                                                        Radius.circular(
                                                                            5.0),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: FlutterFlowTheme.of(
                                                                        context)
                                                                    .primaryText,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            16.0),
                                                              ),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .min,
                                                                children: [
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            5.0,
                                                                            0.0,
                                                                            5.0,
                                                                            0.0),
                                                                    child:
                                                                        wrapWithModel(
                                                                      model: _model
                                                                          .transactionShimmerModel5,
                                                                      updateCallback:
                                                                          () =>
                                                                              safeSetState(() {}),
                                                                      child:
                                                                          TransactionShimmerWidget(
                                                                        index:
                                                                            0,
                                                                        showDivider:
                                                                            false,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          ].divide(SizedBox(
                                                              height: 8.0)),
                                                        ),
                                                      ].divide(SizedBox(
                                                          height: 20.0)),
                                                    ),
                                                  );
                                                } else {
                                                  return Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsetsDirectional
                                                                .fromSTEB(
                                                                    0.0,
                                                                    25.0,
                                                                    0.0,
                                                                    40.0),
                                                        child: Builder(
                                                          builder: (context) {
                                                            final dayGroup = functions
                                                                    .transactionDayGroups(
                                                                        functions
                                                                            .filterTransactionsBy(
                                                                                _model.transactionList.toList(),
                                                                                _model.directionFilter,
                                                                                _model.statusFilter,
                                                                                _model.methodFilter)
                                                                            .toList(),
                                                                        _model.filterIndex)
                                                                    ?.toList() ??
                                                                [];

                                                            return ListView
                                                                .separated(
                                                              padding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              primary: false,
                                                              shrinkWrap: true,
                                                              scrollDirection:
                                                                  Axis.vertical,
                                                              itemCount:
                                                                  dayGroup
                                                                      .length,
                                                              separatorBuilder: (_,
                                                                      __) =>
                                                                  SizedBox(
                                                                      height:
                                                                          20.0),
                                                              itemBuilder: (context,
                                                                  dayGroupIndex) {
                                                                final dayGroupItem =
                                                                    dayGroup[
                                                                        dayGroupIndex];
                                                                return Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  crossAxisAlignment:
                                                                      (FFCrossAxisAlignment
                                                                              .start)
                                                                          .flutterValue,
                                                                  textBaseline:
                                                                      TextBaseline
                                                                          .alphabetic,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional.fromSTEB(
                                                                          4.0,
                                                                          0.0,
                                                                          0.0,
                                                                          0.0),
                                                                      child:
                                                                          Text(
                                                                        getJsonField(
                                                                          dayGroupItem,
                                                                          r'''$.label''',
                                                                        ).toString(),
                                                                        style: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .override(
                                                                              font: GoogleFonts.montserrat(
                                                                                fontWeight: FontWeight.w500,
                                                                                fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                              ),
                                                                              color: Color(0xFF484848),
                                                                              fontSize: 12.0,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w500,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                            ),
                                                                      ),
                                                                    ),
                                                                    Container(
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        color: FlutterFlowTheme.of(context)
                                                                            .primaryText,
                                                                        borderRadius:
                                                                            BorderRadius.circular(16.0),
                                                                      ),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children:
                                                                            [
                                                                          Builder(
                                                                            builder:
                                                                                (context) {
                                                                              final txItem = getJsonField(
                                                                                dayGroupItem,
                                                                                r'''$.rows''',
                                                                              ).toList();

                                                                              return ListView.builder(
                                                                                padding: EdgeInsets.zero,
                                                                                primary: false,
                                                                                shrinkWrap: true,
                                                                                scrollDirection: Axis.vertical,
                                                                                itemCount: txItem.length,
                                                                                itemBuilder: (context, txItemIndex) {
                                                                                  final txItemItem = txItem[txItemIndex];
                                                                                  return InkWell(
                                                                                    splashColor: Colors.transparent,
                                                                                    focusColor: Colors.transparent,
                                                                                    hoverColor: Colors.transparent,
                                                                                    highlightColor: Colors.transparent,
                                                                                    onTap: () async {
                                                                                      context.pushNamed(
                                                                                        PaymentStatusWidget.routeName,
                                                                                        queryParameters: {
                                                                                          'paymentStatus': serializeParam(
                                                                                            functions.transactionStatus(txItemItem),
                                                                                            ParamType.String,
                                                                                          ),
                                                                                          'outcome': serializeParam(
                                                                                            functions.transactionOutcome(txItemItem),
                                                                                            ParamType.JSON,
                                                                                          ),
                                                                                        }.withoutNulls,
                                                                                      );
                                                                                    },
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                        color: FlutterFlowTheme.of(context).primaryText,
                                                                                        borderRadius: BorderRadius.circular(16.0),
                                                                                      ),
                                                                                      child: Padding(
                                                                                        padding: EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 5.0, 0.0),
                                                                                        child: TransactionsWidget(
                                                                                          key: Key('Keya3q_${txItemIndex}_of_${txItem.length}'),
                                                                                          title: functions.transactionTitle(
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
                                                                                                r'''$.direction''',
                                                                                              ).toString(),
                                                                                              getJsonField(
                                                                                                txItemItem,
                                                                                                r'''$.transfer''',
                                                                                              )),
                                                                                          subtitle: functions.transactionRowSubtitle(txItemItem, true),
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
                                                                                          paymentMethod: functions.transactionMethod(txItemItem),
                                                                                          showDivider: functions.groupPairDivider(dayGroupItem, txItemIndex),
                                                                                          tone: functions.transactionTone(
                                                                                              getJsonField(
                                                                                                txItemItem,
                                                                                                r'''$.kind''',
                                                                                              ).toString(),
                                                                                              getJsonField(
                                                                                                txItemItem,
                                                                                                r'''$.direction''',
                                                                                              ).toString(),
                                                                                              getJsonField(
                                                                                                txItemItem,
                                                                                                r'''$.status''',
                                                                                              ).toString()),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  );
                                                                                },
                                                                              );
                                                                            },
                                                                          ),
                                                                        ].divide(SizedBox(height: 7.0)),
                                                                      ),
                                                                    ),
                                                                  ].divide(SizedBox(
                                                                      height:
                                                                          8.0)),
                                                                );
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      ),
                                                      if ((_model.transactionsLoaded ==
                                                              true) &&
                                                          (functions
                                                                  .transactionDayGroups(
                                                                      functions
                                                                          .filterTransactionsBy(
                                                                              _model.transactionList.toList(),
                                                                              _model.directionFilter,
                                                                              _model.statusFilter,
                                                                              _model.methodFilter)
                                                                          .toList(),
                                                                      _model.filterIndex)
                                                                  ?.length ==
                                                              0))
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                      24.0,
                                                                      56.0,
                                                                      24.0,
                                                                      40.0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .min,
                                                            crossAxisAlignment:
                                                                (FFCrossAxisAlignment
                                                                        .center)
                                                                    .flutterValue,
                                                            textBaseline:
                                                                TextBaseline
                                                                    .alphabetic,
                                                            children: [
                                                              ClipRRect(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            0.0),
                                                                child:
                                                                    Image.asset(
                                                                  'assets/images/Coin.png',
                                                                  width: 140.0,
                                                                  height: 140.0,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                ),
                                                              ),
                                                              Text(
                                                                'No Transactions',
                                                                textAlign:
                                                                    TextAlign
                                                                        .center,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .montserrat(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                      ),
                                                                      color: FlutterFlowTheme.of(
                                                                              context)
                                                                          .primaryBackground,
                                                                      fontSize:
                                                                          22.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontStyle: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .fontStyle,
                                                                    ),
                                                              ),
                                                              if (functions.activeTransactionFilters(
                                                                      _model
                                                                          .directionFilter,
                                                                      _model
                                                                          .statusFilter,
                                                                      _model
                                                                          .methodFilter) >
                                                                  0)
                                                                Text(
                                                                  'No transactions match these filters.\nTry changing or clearing them.',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .montserrat(
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        color: Color(
                                                                            0x99000000),
                                                                        fontSize:
                                                                            13.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                        lineHeight:
                                                                            1.5,
                                                                      ),
                                                                ),
                                                              if (functions.activeTransactionFilters(
                                                                      _model
                                                                          .directionFilter,
                                                                      _model
                                                                          .statusFilter,
                                                                      _model
                                                                          .methodFilter) ==
                                                                  0)
                                                                Text(
                                                                  'No transactions in this period.\nTry a longer one above.',
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style: FlutterFlowTheme.of(
                                                                          context)
                                                                      .bodyMedium
                                                                      .override(
                                                                        font: GoogleFonts
                                                                            .montserrat(
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                          fontStyle: FlutterFlowTheme.of(context)
                                                                              .bodyMedium
                                                                              .fontStyle,
                                                                        ),
                                                                        color: Color(
                                                                            0x99000000),
                                                                        fontSize:
                                                                            13.0,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.normal,
                                                                        fontStyle: FlutterFlowTheme.of(context)
                                                                            .bodyMedium
                                                                            .fontStyle,
                                                                        lineHeight:
                                                                            1.5,
                                                                      ),
                                                                ),
                                                              if (functions.activeTransactionFilters(
                                                                      _model
                                                                          .directionFilter,
                                                                      _model
                                                                          .statusFilter,
                                                                      _model
                                                                          .methodFilter) >
                                                                  0)
                                                                Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0.0,
                                                                          4.0,
                                                                          0.0,
                                                                          0.0),
                                                                  child:
                                                                      InkWell(
                                                                    splashColor:
                                                                        Colors
                                                                            .transparent,
                                                                    focusColor:
                                                                        Colors
                                                                            .transparent,
                                                                    hoverColor:
                                                                        Colors
                                                                            .transparent,
                                                                    highlightColor:
                                                                        Colors
                                                                            .transparent,
                                                                    onTap:
                                                                        () async {
                                                                      _model.directionFilter =
                                                                          'All';
                                                                      _model.statusFilter =
                                                                          'All';
                                                                      _model.methodFilter =
                                                                          'All types';
                                                                      safeSetState(
                                                                          () {});
                                                                    },
                                                                    child: Text(
                                                                      'Clear filters',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: FlutterFlowTheme.of(
                                                                              context)
                                                                          .bodyMedium
                                                                          .override(
                                                                            font:
                                                                                GoogleFonts.montserrat(
                                                                              fontWeight: FontWeight.w600,
                                                                              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                            ),
                                                                            color:
                                                                                FlutterFlowTheme.of(context).primaryBackground,
                                                                            fontSize:
                                                                                14.0,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontStyle:
                                                                                FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                                                                            decoration:
                                                                                TextDecoration.underline,
                                                                          ),
                                                                    ),
                                                                  ),
                                                                ),
                                                            ].divide(SizedBox(
                                                                height: 8.0)),
                                                          ),
                                                        ),
                                                    ],
                                                  );
                                                }
                                              },
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
