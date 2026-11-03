import '/components/transaction_shimmer_widget.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'orders_model.dart';
export 'orders_model.dart';

class OrdersWidget extends StatefulWidget {
  const OrdersWidget({super.key});

  static String routeName = 'Orders';
  static String routePath = '/orders';

  @override
  State<OrdersWidget> createState() => _OrdersWidgetState();
}

class _OrdersWidgetState extends State<OrdersWidget> {
  late OrdersModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OrdersModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _model.loadOrders(context);
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
                padding: EdgeInsetsDirectional.fromSTEB(15.0, 86.0, 15.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
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
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            size: 24.0,
                          ),
                        ),
                        Text(
                          'Orders',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
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
                        SizedBox(width: 24.0),
                      ],
                    ),
                    Expanded(
                      child: Builder(
                        builder: (context) {
                          if (!_model.loaded) {
                            return Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 25.0, 0.0, 0.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16.0),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        wrapWithModel(
                                          model:
                                              _model.transactionShimmerModel1,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: TransactionShimmerWidget(
                                            index: 0,
                                            showDivider: true,
                                          ),
                                        ),
                                        wrapWithModel(
                                          model:
                                              _model.transactionShimmerModel2,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: TransactionShimmerWidget(
                                            index: 1,
                                            showDivider: true,
                                          ),
                                        ),
                                        wrapWithModel(
                                          model:
                                              _model.transactionShimmerModel3,
                                          updateCallback: () =>
                                              safeSetState(() {}),
                                          child: TransactionShimmerWidget(
                                            index: 2,
                                            showDivider: false,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          } else if (getJsonField(
                                _model.orders,
                                r'''$.ok''',
                              ) !=
                              true) {
                            return Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment:
                                  (FFMainAxisAlignment.center).flutterValue,
                              children: [
                                Container(
                                  width: 64.0,
                                  height: 64.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFEBEBEB),
                                    shape: BoxShape.circle,
                                  ),
                                  alignment: AlignmentDirectional(0.0, 0.0),
                                  child: Icon(
                                    Icons.cloud_off_rounded,
                                    color: Color(0x84000000),
                                    size: 28.0,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 15.0, 0.0, 0.0),
                                  child: Text(
                                    'Couldn’t load your orders',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          fontSize: 18.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      5.0, 8.0, 5.0, 0.0),
                                  child: Text(
                                    'Check your connection and try again.',
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: Color(0x67000000),
                                          fontSize: 13.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                          lineHeight: 1.4,
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      15.0, 20.0, 15.0, 120.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      _model.loaded = false;
                                      safeSetState(() {});
                                      await _model.loadOrders(context);
                                      safeSetState(() {});
                                    },
                                    child: Container(
                                      width: 166.8,
                                      height: 40.37,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .primaryBackground,
                                        borderRadius:
                                            BorderRadius.circular(106.67),
                                      ),
                                      alignment: AlignmentDirectional(0.0, 0.0),
                                      child: Text(
                                        'Try again',
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
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .primaryText,
                                              fontSize: 16.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w500,
                                              fontStyle:
                                                  FlutterFlowTheme.of(context)
                                                      .bodyMedium
                                                      .fontStyle,
                                            ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          } else if ((getJsonField(
                                _model.orders,
                                r'''$.orders''',
                                true,
                              ) as List?)
                                  ?.isEmpty ??
                              true) {
                            return Column(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment:
                                  (FFMainAxisAlignment.center).flutterValue,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.asset(
                                    'assets/images/shoppig_troll.png',
                                    width: 183.6,
                                    height: 194.1,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 15.0, 0.0, 0.0),
                                  child: Text(
                                    'No Orders Yet',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          fontSize: 18.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      5.0, 8.0, 5.0, 120.0),
                                  child: Text(
                                    'When a customer pays for a sale with your products in it, the order shows up here.',
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.w600,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: Color(0x67000000),
                                          fontSize: 13.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w600,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                          lineHeight: 1.4,
                                        ),
                                  ),
                                ),
                              ],
                            );
                          } else {
                            return Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 25.0, 0.0, 0.0),
                              child: RefreshIndicator(
                                color: FlutterFlowTheme.of(context)
                                    .primaryBackground,
                                onRefresh: () async {
                                  await _model.loadOrders(context);
                                  safeSetState(() {});
                                },
                                child: Builder(
                                  builder: (context) {
                                    final orderItem = (getJsonField(
                                          _model.orders,
                                          r'''$.orders''',
                                          true,
                                        ) as List?)
                                            ?.toList() ??
                                        [];

                                    return ListView.separated(
                                      padding: EdgeInsets.fromLTRB(
                                        0,
                                        0,
                                        0,
                                        35.0,
                                      ),
                                      scrollDirection: Axis.vertical,
                                      itemCount: orderItem.length,
                                      separatorBuilder: (_, __) =>
                                          SizedBox(height: 10.0),
                                      itemBuilder: (context, orderItemIndex) {
                                        final orderItemItem =
                                            orderItem[orderItemIndex];
                                        return _orderCard(
                                            orderItemItem, orderItemIndex);
                                      },
                                    );
                                  },
                                ),
                              ),
                            );
                          }
                        },
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

  TextStyle _style(
    BuildContext context, {
    required FontWeight weight,
    required Color color,
    required double size,
    double? lineHeight,
  }) =>
      FlutterFlowTheme.of(context).bodyMedium.override(
            font: GoogleFonts.montserrat(
              fontWeight: weight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
            color: color,
            fontSize: size,
            letterSpacing: 0.0,
            fontWeight: weight,
            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            lineHeight: lineHeight,
          );

  Widget _orderCard(dynamic orderItemItem, int orderItemIndex) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        _model.openOrder =
            _model.openOrder == orderItemIndex ? -1 : orderItemIndex;
        safeSetState(() {});
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(14.0, 14.0, 14.0, 14.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: 40.0,
                    height: 40.0,
                    decoration: BoxDecoration(
                      color: Color(0xFFF1F1F1),
                      shape: BoxShape.circle,
                    ),
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Image.asset(
                      'assets/images/bag.png',
                      width: 18.0,
                      height: 18.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment:
                          (FFCrossAxisAlignment.start).flutterValue,
                      children: [
                        Text(
                          getJsonField(
                            orderItemItem,
                            r'''$.title''',
                          ).toString(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _style(context,
                              weight: FontWeight.w600,
                              color: Color(0xFF111111),
                              size: 13.0,
                              lineHeight: 1.54),
                        ),
                        Text(
                          '${getJsonField(orderItemItem, r'''$.items''').toString()} · ${getJsonField(orderItemItem, r'''$.paidBy''').toString()}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: _style(context,
                              weight: FontWeight.normal,
                              color: Color(0x84000000),
                              size: 10.0,
                              lineHeight: 1.5),
                        ),
                      ].divide(SizedBox(height: 2.0)),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: (FFCrossAxisAlignment.end).flutterValue,
                    children: [
                      Text(
                        getJsonField(
                          orderItemItem,
                          r'''$.amount''',
                        ).toString(),
                        style: _style(context,
                            weight: FontWeight.bold,
                            color: Color(0xFF111111),
                            size: 13.0,
                            lineHeight: 1.54),
                      ),
                      Text(
                        getJsonField(
                          orderItemItem,
                          r'''$.when''',
                        ).toString(),
                        style: _style(context,
                            weight: FontWeight.normal,
                            color: Color(0x84000000),
                            size: 10.0,
                            lineHeight: 1.5),
                      ),
                    ].divide(SizedBox(height: 2.0)),
                  ),
                  if (_model.openOrder != orderItemIndex)
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0x73000000),
                      size: 20.0,
                    ),
                  if (_model.openOrder == orderItemIndex)
                    Icon(
                      Icons.keyboard_arrow_up_rounded,
                      color: Color(0x73000000),
                      size: 20.0,
                    ),
                ].divide(SizedBox(width: 10.0)),
              ),
              if (_model.openOrder == orderItemIndex)
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Color(0xFFEDEDED), width: 1.0),
                      ),
                    ),
                    child: Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Builder(
                            builder: (context) {
                              final lineItem = (getJsonField(
                                    orderItemItem,
                                    r'''$.lines''',
                                    true,
                                  ) as List?)
                                      ?.toList() ??
                                  [];

                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(lineItem.length,
                                    (lineItemIndex) {
                                  final lineItemItem = lineItem[lineItemIndex];
                                  return Row(
                                    mainAxisSize: MainAxisSize.max,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          getJsonField(
                                            lineItemItem,
                                            r'''$.name''',
                                          ).toString(),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: _style(context,
                                              weight: FontWeight.w500,
                                              color: Color(0xFF111111),
                                              size: 12.0,
                                              lineHeight: 1.5),
                                        ),
                                      ),
                                      Text(
                                        getJsonField(
                                          lineItemItem,
                                          r'''$.quantity''',
                                        ).toString(),
                                        style: _style(context,
                                            weight: FontWeight.normal,
                                            color: Color(0x84000000),
                                            size: 12.0,
                                            lineHeight: 1.5),
                                      ),
                                      Text(
                                        getJsonField(
                                          lineItemItem,
                                          r'''$.amount''',
                                        ).toString(),
                                        style: _style(context,
                                            weight: FontWeight.w600,
                                            color: Color(0xFF111111),
                                            size: 12.0,
                                            lineHeight: 1.5),
                                      ),
                                    ].divide(SizedBox(width: 12.0)),
                                  );
                                }).divide(SizedBox(height: 8.0)),
                              );
                            },
                          ),
                          Align(
                            alignment: AlignmentDirectional(-1.0, 0.0),
                            child: Text(
                              'Order ${getJsonField(orderItemItem, r'''$.code''').toString()}',
                              style: _style(context,
                                  weight: FontWeight.normal,
                                  color: Color(0x84000000),
                                  size: 10.0,
                                  lineHeight: 1.5),
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
      ),
    );
  }
}
