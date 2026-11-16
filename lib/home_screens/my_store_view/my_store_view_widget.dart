import '/components/product_card/product_card_widget.dart';
import '/components/product_shimmer_grid/product_shimmer_grid_widget.dart';
import '/components/products_menu_sheet/products_menu_sheet_widget.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home_screens/new_order_flow/select_pay_out/select_pay_out_widget.dart';
import 'dart:math';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'my_store_view_model.dart';
export 'my_store_view_model.dart';

/// My Store, the second tab of the bottom bar.
///
/// The merchant's products as a grid: tap one to add it to the cart, step its
/// quantity, then Charge the whole cart. The ⋮ button opens the Products menu
/// (Add product / Manage products).
class MyStoreViewWidget extends StatefulWidget {
  const MyStoreViewWidget({super.key});

  @override
  State<MyStoreViewWidget> createState() => _MyStoreViewWidgetState();
}

class _MyStoreViewWidgetState extends State<MyStoreViewWidget>
    with TickerProviderStateMixin {
  late MyStoreViewModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MyStoreViewModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _model.loadProducts(context);
      safeSetState(() {});
    });

    animationsMap.addAll({
      'rowOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeOut,
            delay: 0.0.ms,
            duration: 280.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeOut,
            delay: 0.0.ms,
            duration: 280.0.ms,
            begin: Offset(0.0, 10.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'imageOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeOut,
            delay: 0.0.ms,
            duration: 360.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          ScaleEffect(
            curve: Curves.easeOut,
            delay: 0.0.ms,
            duration: 480.0.ms,
            begin: Offset(0.9, 0.9),
            end: Offset(1.0, 1.0),
          ),
        ],
      ),
      'columnOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeOut,
            delay: 90.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeOut,
            delay: 90.0.ms,
            duration: 300.0.ms,
            begin: Offset(0.0, 12.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeOut,
            delay: 180.0.ms,
            duration: 300.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          MoveEffect(
            curve: Curves.easeOut,
            delay: 180.0.ms,
            duration: 300.0.ms,
            begin: Offset(0.0, 12.0),
            end: Offset(0.0, 0.0),
          ),
        ],
      ),
      'productCardOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          FadeEffect(
            curve: Curves.easeOut,
            delay: 0.0.ms,
            duration: 320.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          ScaleEffect(
            curve: Curves.easeOut,
            delay: 0.0.ms,
            duration: 420.0.ms,
            begin: Offset(0.92, 0.92),
            end: Offset(1.0, 1.0),
          ),
          MoveEffect(
            curve: Curves.easeOut,
            delay: 0.0.ms,
            duration: 420.0.ms,
            begin: Offset(0.0, 18.0),
            end: Offset(0.0, 0.0),
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
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFF5F5F7),
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
                    fit: BoxFit.fill,
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
              crossAxisAlignment: (FFCrossAxisAlignment.start).flutterValue,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 55.0, 0.0, 0.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment:
                        (FFMainAxisAlignment.spaceBetween).flutterValue,
                    children: [
                      Container(
                        width: 32.0,
                        height: 32.0,
                        decoration: BoxDecoration(),
                      ),
                      Text(
                        'My Store',
                        textAlign: TextAlign.center,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.montserrat(
                                fontWeight: FontWeight.w600,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              fontSize: 15.0,
                              letterSpacing: 0.0,
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                      ),
                      InkWell(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        hoverColor: Colors.transparent,
                        highlightColor: Colors.transparent,
                        onTap: () async {
                          await showModalBottomSheet(
                            isScrollControlled: true,
                            backgroundColor: Colors.transparent,
                            context: context,
                            builder: (context) {
                              return Padding(
                                padding: MediaQuery.viewInsetsOf(context),
                                child: ProductsMenuSheetWidget(),
                              );
                            },
                          ).then((value) =>
                              safeSetState(() => _model.menuChoice = value));

                          if (_model.menuChoice == 'add') {
                            await actions.haatOpenAndWait(
                              context,
                              'AddProduct',
                              '',
                              <String, dynamic>{},
                            );
                            await _model.loadProducts(context);
                            safeSetState(() {});
                          } else if (_model.menuChoice == 'manage') {
                            await actions.haatOpenAndWait(
                              context,
                              'Products',
                              '',
                              <String, dynamic>{},
                            );
                            await _model.loadProducts(context);
                            safeSetState(() {});
                          }

                          safeSetState(() {});
                        },
                        child: Container(
                          width: 32.0,
                          height: 32.0,
                          decoration: BoxDecoration(),
                          alignment: AlignmentDirectional(1.0, 0.0),
                          child: Icon(
                            Icons.more_vert_rounded,
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            size: 24.0,
                          ),
                        ),
                      ),
                    ],
                  ).animateOnPageLoad(animationsMap['rowOnPageLoadAnimation']!),
                ),
                Expanded(
                  child: Builder(
                    builder: (context) {
                      if (_model.productsLoaded == false) {
                        return Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 20.0, 0.0, 0.0),
                          child: wrapWithModel(
                            model: _model.productShimmerGridModel,
                            updateCallback: () => safeSetState(() {}),
                            child: ProductShimmerGridWidget(),
                          ),
                        );
                      } else if (!(_model.products.isNotEmpty)) {
                        return Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              10.0, 0.0, 10.0, 110.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment:
                                (FFMainAxisAlignment.center).flutterValue,
                            crossAxisAlignment:
                                (FFCrossAxisAlignment.center).flutterValue,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(0.0),
                                child: Image.asset(
                                  'assets/images/shoppig_troll.png',
                                  width: 168.0,
                                  height: 168.0,
                                  fit: BoxFit.contain,
                                ),
                              ).animateOnPageLoad(
                                  animationsMap['imageOnPageLoadAnimation']!),
                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    'No Products Yet',
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.montserrat(
                                            fontWeight: FontWeight.bold,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                          color: FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                          fontSize: 22.0,
                                          letterSpacing: -0.3,
                                          fontWeight: FontWeight.bold,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                        ),
                                  ),
                                  Text(
                                    'The products you sell will show here. Tap one to add it to a sale, then charge the whole cart at once.',
                                    textAlign: TextAlign.center,
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
                                          color: Color(0x8C000000),
                                          fontSize: 13.0,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.w500,
                                          fontStyle:
                                              FlutterFlowTheme.of(context)
                                                  .bodyMedium
                                                  .fontStyle,
                                          lineHeight: 1.45,
                                        ),
                                  ),
                                ].divide(SizedBox(height: 8.0)),
                              ).animateOnPageLoad(
                                  animationsMap['columnOnPageLoadAnimation']!),
                              Padding(
                                padding: EdgeInsetsDirectional.fromSTEB(
                                    0.0, 12.0, 0.0, 0.0),
                                child: InkWell(
                                  splashColor: Colors.transparent,
                                  focusColor: Colors.transparent,
                                  hoverColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  onTap: () async {
                                    await actions.haatOpenAndWait(
                                      context,
                                      'AddProduct',
                                      '',
                                      <String, dynamic>{},
                                    );
                                    await _model.loadProducts(context);
                                    safeSetState(() {});
                                  },
                                  child: Container(
                                    width: 163.0,
                                    height: 44.0,
                                    decoration: BoxDecoration(
                                      color: FlutterFlowTheme.of(context)
                                          .primaryBackground,
                                      borderRadius:
                                          BorderRadius.circular(106.67),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          (FFMainAxisAlignment.center)
                                              .flutterValue,
                                      children: [
                                        Icon(
                                          Icons.add_rounded,
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          size: 20.0,
                                        ),
                                        Text(
                                          'Add Product',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.w600,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                              context)
                                                          .bodyMedium
                                                          .fontStyle,
                                                ),
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                                fontSize: 15.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.w600,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                        ),
                                      ].divide(SizedBox(width: 6.0)),
                                    ),
                                  ),
                                ).animateOnPageLoad(animationsMap[
                                    'containerOnPageLoadAnimation']!),
                              ),
                            ].divide(SizedBox(height: 12.0)),
                          ),
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              0.0, 20.0, 0.0, 0.0),
                          child: Builder(
                            builder: (context) {
                              final productItem = _model.products.toList();

                              return GridView.builder(
                                padding: EdgeInsets.fromLTRB(
                                  0,
                                  0,
                                  0,
                                  220.0,
                                ),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10.0,
                                  mainAxisSpacing: 10.0,
                                  childAspectRatio: 0.83,
                                ),
                                scrollDirection: Axis.vertical,
                                itemCount: productItem.length,
                                itemBuilder: (context, productItemIndex) {
                                  final productItemItem =
                                      productItem[productItemIndex];
                                  return ProductCardWidget(
                                    key: Key(
                                        'Keyhqp_${productItemIndex}_of_${productItem.length}'),
                                    name: getJsonField(
                                      productItemItem,
                                      r'''$.name''',
                                    ).toString(),
                                    priceLabel: getJsonField(
                                      productItemItem,
                                      r'''$.priceLabel''',
                                    ).toString(),
                                    unit: getJsonField(
                                      productItemItem,
                                      r'''$.unit''',
                                    ).toString(),
                                    imageUrl: getJsonField(
                                      productItemItem,
                                      r'''$.imageUrl''',
                                    ).toString(),
                                    quantity: functions.cartQuantity(
                                        _model.cart.toList(),
                                        getJsonField(
                                          productItemItem,
                                          r'''$.id''',
                                        ).toString()),
                                    selected: functions.productInCart(
                                        _model.cart.toList(),
                                        getJsonField(
                                          productItemItem,
                                          r'''$.id''',
                                        ).toString()),
                                    outOfStock: getJsonField(
                                      productItemItem,
                                      r'''$.outOfStock''',
                                    ),
                                    onTap: () async {
                                      if (getJsonField(
                                        productItemItem,
                                        r'''$.outOfStock''',
                                      )) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              '${functions.notificationText(productItemItem, 'name', '')} is out of stock. Change its quantity in Manage products to sell it again.',
                                              style: TextStyle(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .primaryText,
                                              ),
                                            ),
                                            duration:
                                                Duration(milliseconds: 4000),
                                            backgroundColor:
                                                FlutterFlowTheme.of(context)
                                                    .secondary,
                                          ),
                                        );
                                        return;
                                      }
                                      if (functions.productInCart(
                                              _model.cart.toList(),
                                              getJsonField(
                                                productItemItem,
                                                r'''$.id''',
                                              ).toString()) ==
                                          true) {
                                        return;
                                      }
                                      _model.cart = functions
                                          .cartToggle(
                                              _model.cart.toList(),
                                              productItemItem,
                                              FFDevEnvironmentValues().baseURL)!
                                          .toList()
                                          .cast<dynamic>();
                                      safeSetState(() {});
                                    },
                                    onIncrement: () async {
                                      _model.cart = functions
                                          .cartChangeQuantity(
                                              _model.cart.toList(),
                                              getJsonField(
                                                productItemItem,
                                                r'''$.id''',
                                              ).toString(),
                                              1)
                                          .toList()
                                          .cast<dynamic>();
                                      safeSetState(() {});
                                    },
                                    onDecrement: () async {
                                      _model.cart = functions
                                          .cartChangeQuantity(
                                              _model.cart.toList(),
                                              getJsonField(
                                                productItemItem,
                                                r'''$.id''',
                                              ).toString(),
                                              -1)
                                          .toList()
                                          .cast<dynamic>();
                                      safeSetState(() {});
                                    },
                                  ).animateOnPageLoad(animationsMap[
                                      'productCardOnPageLoadAnimation']!);
                                },
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            child: custom_widgets.AddProductBar(
              width: double.infinity,
              height: double.infinity,
              currency: 'SDG',
              bottomGap: 35.0,
              cart: _model.cart,
              products: _model.products,
              onCharge: (totalMinor) async {
                await actions.haatSetSaleCart(
                  _model.cart.toList(),
                );
                await showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  enableDrag: false,
                  context: context,
                  builder: (context) {
                    return Padding(
                      padding: MediaQuery.viewInsetsOf(context),
                      child: SelectPayOutWidget(
                        amountPay: functions.moneyLabel(totalMinor),
                      ),
                    );
                  },
                ).then((value) => safeSetState(() {}));
              },
            ),
          ),
        ],
      ),
    );
  }
}
