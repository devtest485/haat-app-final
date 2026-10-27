import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

import 'dart:ui';

import '/backend/api_requests/api_calls.dart';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';

import 'package:flutter/scheduler.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '/components/empty_state/empty_state_widget.dart';

import 'products_model.dart';
export 'products_model.dart';

class ProductsWidget extends StatefulWidget {
  const ProductsWidget({super.key});

  static String routeName = 'Products';
  static String routePath = '/products';

  @override
  State<ProductsWidget> createState() => _ProductsWidgetState();
}

class _ProductsWidgetState extends State<ProductsWidget> {
  late ProductsModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ProductsModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.token = await actions.haatAccessToken();
      _model.productsResult = await HaatAuthGroup.productsCall.call(
        accessToken: _model.token,
      );

      if ((_model.productsResult?.succeeded ?? true)) {
        _model.products = functions
            .myProducts(HaatAuthGroup.productsCall
                .products((_model.productsResult?.jsonBody ?? ''))
                ?.toList())
            .toList()
            .cast<dynamic>();
        _model.loadError = '';
        _model.productsLoaded = true;
        safeSetState(() {});
      } else {
        _model.loadError =
            'Your products could not be loaded. Check your connection and open this page again.';
        _model.productsLoaded = true;
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
            alignment: AlignmentDirectional(0.0, 1.0),
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
                        image:
                            Image.asset('assets/images/GrayPageBg.png').image,
                      ),
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                        15.0,
                        0.0,
                        15.0,
                        0.0,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              0.0,
                              67.0,
                              0.0,
                              0.0,
                            ),
                            child: Container(
                              decoration: BoxDecoration(),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0,
                                      19.0,
                                      0.0,
                                      0.0,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          (FFMainAxisAlignment.spaceBetween)
                                              .flutterValue,
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
                                          'Products',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                    context,
                                                  ).bodyMedium.fontStyle,
                                                ),
                                                color: FlutterFlowTheme.of(
                                                  context,
                                                ).primaryBackground,
                                                fontSize: 15.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FlutterFlowTheme.of(
                                                  context,
                                                ).bodyMedium.fontStyle,
                                              ),
                                        ),
                                        Text(
                                          '.',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                    context,
                                                  ).bodyMedium.fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                    context,
                                                  ).bodyMedium.fontStyle,
                                                ),
                                                letterSpacing: 0.0,
                                                fontWeight: FlutterFlowTheme.of(
                                                  context,
                                                ).bodyMedium.fontWeight,
                                                fontStyle: FlutterFlowTheme.of(
                                                  context,
                                                ).bodyMedium.fontStyle,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                0.0,
                                25.0,
                                0.0,
                                0.0,
                              ),
                              child: Builder(
                                builder: (context) {
                                  if (!_model.productsLoaded) {
                                    return Center(
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
                                    );
                                  } else if (_model.loadError != '') {
                                    return Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0,
                                        40.0,
                                        0.0,
                                        0.0,
                                      ),
                                      child: Text(
                                        _model.loadError,
                                        textAlign: TextAlign.center,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.montserrat(
                                                fontWeight: FontWeight.normal,
                                                fontStyle: FlutterFlowTheme.of(
                                                  context,
                                                ).bodyMedium.fontStyle,
                                              ),
                                              color: Color(0xFF484848),
                                              fontSize: 13.0,
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.normal,
                                              fontStyle: FlutterFlowTheme.of(
                                                context,
                                              ).bodyMedium.fontStyle,
                                            ),
                                      ),
                                    );
                                  } else if (_model.products.length == 0) {
                                    // Centered in the space under the header, with its own way to add the first one.
                                    return Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                        0.0,
                                        0.0,
                                        0.0,
                                        90.0,
                                      ),
                                      child: wrapWithModel(
                                        model: _model.emptyStateModel,
                                        updateCallback: () =>
                                            safeSetState(() {}),
                                        child: EmptyStateWidget(
                                          icon: Icon(
                                            Icons.inventory_2_outlined,
                                            color: Color(0xFF00A85B),
                                            size: 30.0,
                                          ),
                                          title: 'No products yet',
                                          body:
                                              'Add what you sell and it shows up in your Cashier, ready to tap.',
                                          buttonLabel: 'Add Product',
                                          onPressed: () async {
                                            await context.pushNamed(
                                              AddProductWidget.routeName,
                                            );

                                            _model.productsResult =
                                                await HaatAuthGroup.productsCall
                                                    .call(
                                              accessToken: _model.token,
                                            );

                                            if ((_model.productsResult
                                                    ?.succeeded ??
                                                true)) {
                                              _model.products = functions
                                                  .myProducts(
                                                    HaatAuthGroup.productsCall
                                                        .products(
                                                          (_model.productsResult
                                                                  ?.jsonBody ??
                                                              ''),
                                                        )
                                                        ?.toList(),
                                                  )
                                                  .toList()
                                                  .cast<dynamic>();
                                              _model.loadError = '';
                                              safeSetState(() {});
                                            }
                                          },
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Builder(
                                      builder: (context) {
                                        final productItem =
                                            _model.products.toList();

                                        return GridView.builder(
                                          padding: EdgeInsets.fromLTRB(
                                            0,
                                            0,
                                            0,
                                            110.0,
                                          ),
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 10.0,
                                            mainAxisSpacing: 10.0,
                                            childAspectRatio: 0.78,
                                          ),
                                          scrollDirection: Axis.vertical,
                                          itemCount: productItem.length,
                                          itemBuilder:
                                              (context, productItemIndex) {
                                            final productItemItem =
                                                productItem[productItemIndex];
                                            return InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                if (getJsonField(
                                                      productItemItem,
                                                      r'''$.isMine''',
                                                    ) ==
                                                    true) {
                                                  await context.pushNamed(
                                                    EditProductWidget.routeName,
                                                    queryParameters: {
                                                      'product': serializeParam(
                                                        productItemItem,
                                                        ParamType.JSON,
                                                      ),
                                                    }.withoutNulls,
                                                  );

                                                  _model.productsResult =
                                                      await HaatAuthGroup
                                                          .productsCall
                                                          .call(
                                                    accessToken: _model.token,
                                                  );

                                                  if ((_model.productsResult
                                                          ?.succeeded ??
                                                      true)) {
                                                    _model.products = functions
                                                        .myProducts(
                                                          HaatAuthGroup
                                                              .productsCall
                                                              .products(
                                                                (_model.productsResult
                                                                        ?.jsonBody ??
                                                                    ''),
                                                              )
                                                              ?.toList(),
                                                        )
                                                        .toList()
                                                        .cast<dynamic>();
                                                    safeSetState(() {});
                                                  }
                                                }
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  color: FlutterFlowTheme.of(
                                                    context,
                                                  ).primaryText,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    12.0,
                                                  ),
                                                  border: Border.all(
                                                    color: FlutterFlowTheme.of(
                                                      context,
                                                    ).primaryText,
                                                  ),
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsetsDirectional
                                                      .fromSTEB(
                                                    10.0,
                                                    5.0,
                                                    10.0,
                                                    8.0,
                                                  ),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        (FFCrossAxisAlignment
                                                                .start)
                                                            .flutterValue,
                                                    children: [
                                                      Opacity(
                                                        opacity: functions
                                                            .productCardOpacity(
                                                          getJsonField(
                                                            productItemItem,
                                                            r'''$.outOfStock''',
                                                          ),
                                                        ),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              (FFCrossAxisAlignment
                                                                      .start)
                                                                  .flutterValue,
                                                          children: [
                                                            Builder(
                                                              builder:
                                                                  (context) {
                                                                if (functions
                                                                    .productHasPhoto(
                                                                  getJsonField(
                                                                    productItemItem,
                                                                    r'''$.imagePath''',
                                                                  ).toString(),
                                                                )) {
                                                                  return ClipRRect(
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .only(),
                                                                    child: Image
                                                                        .network(
                                                                      functions
                                                                          .bannerImageUrl(
                                                                        getJsonField(
                                                                          productItemItem,
                                                                          r'''$.imagePath''',
                                                                        ).toString(),
                                                                        FFDevEnvironmentValues()
                                                                            .baseURL,
                                                                      ),
                                                                      width: double
                                                                          .infinity,
                                                                      height:
                                                                          110.0,
                                                                      fit: BoxFit
                                                                          .contain,
                                                                    ),
                                                                  );
                                                                } else {
                                                                  return Container(
                                                                    width: double
                                                                        .infinity,
                                                                    height:
                                                                        110.0,
                                                                    alignment:
                                                                        AlignmentDirectional(
                                                                      0.0,
                                                                      0.0,
                                                                    ),
                                                                    child: Icon(
                                                                      Icons
                                                                          .image_outlined,
                                                                      color:
                                                                          Color(
                                                                        0x40000000,
                                                                      ),
                                                                      size:
                                                                          36.0,
                                                                    ),
                                                                  );
                                                                }
                                                              },
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                0.0,
                                                                10.0,
                                                                0.0,
                                                                0.0,
                                                              ),
                                                              child: Text(
                                                                '${functions.moneyLabel(getJsonField(productItemItem, r'''$.priceMinor''').toString())} SDG',
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .montserrat(
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontStyle:
                                                                            FlutterFlowTheme.of(
                                                                          context,
                                                                        ).bodyMedium.fontStyle,
                                                                      ),
                                                                      color:
                                                                          FlutterFlowTheme
                                                                              .of(
                                                                        context,
                                                                      ).primaryBackground,
                                                                      fontSize:
                                                                          18.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontStyle:
                                                                          FlutterFlowTheme
                                                                              .of(
                                                                        context,
                                                                      ).bodyMedium.fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                0.0,
                                                                3.0,
                                                                0.0,
                                                                0.0,
                                                              ),
                                                              child: Text(
                                                                getJsonField(
                                                                  productItemItem,
                                                                  r'''$.name''',
                                                                ).toString(),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .montserrat(
                                                                        fontWeight:
                                                                            FlutterFlowTheme.of(
                                                                          context,
                                                                        ).bodyMedium.fontWeight,
                                                                        fontStyle:
                                                                            FlutterFlowTheme.of(
                                                                          context,
                                                                        ).bodyMedium.fontStyle,
                                                                      ),
                                                                      color:
                                                                          FlutterFlowTheme
                                                                              .of(
                                                                        context,
                                                                      ).primaryBackground,
                                                                      fontSize:
                                                                          13.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FlutterFlowTheme
                                                                              .of(
                                                                        context,
                                                                      ).bodyMedium.fontWeight,
                                                                      fontStyle:
                                                                          FlutterFlowTheme
                                                                              .of(
                                                                        context,
                                                                      ).bodyMedium.fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                0.0,
                                                                6.0,
                                                                0.0,
                                                                0.0,
                                                              ),
                                                              child: Text(
                                                                getJsonField(
                                                                  productItemItem,
                                                                  r'''$.unit''',
                                                                ).toString(),
                                                                maxLines: 1,
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                style: FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .override(
                                                                      font: GoogleFonts
                                                                          .montserrat(
                                                                        fontWeight:
                                                                            FlutterFlowTheme.of(
                                                                          context,
                                                                        ).bodyMedium.fontWeight,
                                                                        fontStyle:
                                                                            FlutterFlowTheme.of(
                                                                          context,
                                                                        ).bodyMedium.fontStyle,
                                                                      ),
                                                                      color:
                                                                          Color(
                                                                        0x73000000,
                                                                      ),
                                                                      fontSize:
                                                                          10.0,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FlutterFlowTheme
                                                                              .of(
                                                                        context,
                                                                      ).bodyMedium.fontWeight,
                                                                      fontStyle:
                                                                          FlutterFlowTheme
                                                                              .of(
                                                                        context,
                                                                      ).bodyMedium.fontStyle,
                                                                    ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      if (functions.stockLabel(
                                                            getJsonField(
                                                              productItemItem,
                                                              r'''$.quantity''',
                                                            ),
                                                          ) !=
                                                          '')
                                                        Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                            0.0,
                                                            6.0,
                                                            0.0,
                                                            0.0,
                                                          ),
                                                          child: Text(
                                                            functions
                                                                .stockLabel(
                                                              getJsonField(
                                                                productItemItem,
                                                                r'''$.quantity''',
                                                              ),
                                                            ),
                                                            style: FlutterFlowTheme
                                                                    .of(context)
                                                                .bodyMedium
                                                                .override(
                                                                  font: GoogleFonts
                                                                      .montserrat(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    fontStyle:
                                                                        FlutterFlowTheme
                                                                            .of(
                                                                      context,
                                                                    ).bodyMedium.fontStyle,
                                                                  ),
                                                                  color:
                                                                      FlutterFlowTheme
                                                                          .of(
                                                                    context,
                                                                  ).primaryBackground,
                                                                  fontSize:
                                                                      11.0,
                                                                  letterSpacing:
                                                                      0.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontStyle: FlutterFlowTheme
                                                                          .of(
                                                                    context,
                                                                  )
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                                ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (_model.products.length > 0)
                Padding(
                  padding:
                      EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 35.0),
                  child: InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      await context.pushNamed(AddProductWidget.routeName);

                      _model.productsResult = await HaatAuthGroup.productsCall
                          .call(accessToken: _model.token);

                      if ((_model.productsResult?.succeeded ?? true)) {
                        _model.products = functions
                            .myProducts(HaatAuthGroup.productsCall
                                .products(
                                    (_model.productsResult?.jsonBody ?? ''))
                                ?.toList())
                            .toList()
                            .cast<dynamic>();
                        _model.loadError = '';
                        safeSetState(() {});
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 50.0,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        borderRadius: BorderRadius.circular(106.67),
                      ),
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Text(
                        'Add Product',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.montserrat(
                                fontWeight: FontWeight.bold,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context).primaryText,
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
      ),
    );
  }
}
