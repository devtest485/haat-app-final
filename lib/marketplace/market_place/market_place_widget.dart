import '/backend/api_requests/api_calls.dart';
import '/components/market_biller_tile/market_biller_tile_widget.dart';
import '/components/market_brand_card/market_brand_card_widget.dart';
import '/components/market_category_tile/market_category_tile_widget.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/marketplace/market_space/market_space_widget.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'market_place_model.dart';
export 'market_place_model.dart';

class MarketPlaceWidget extends StatefulWidget {
  const MarketPlaceWidget({super.key});

  @override
  State<MarketPlaceWidget> createState() => _MarketPlaceWidgetState();
}

class _MarketPlaceWidgetState extends State<MarketPlaceWidget> {
  late MarketPlaceModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MarketPlaceModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.token = await actions.haatAccessToken();
      _model.bannersResult = await HaatAuthGroup.marketplaceBannersCall.call(
        accessToken: _model.token,
        placement: 'marketplace',
      );

      _model.marketplaceResult = await HaatAuthGroup.marketplaceCall.call(
        accessToken: _model.token,
      );

      if ((_model.marketplaceResult?.succeeded ?? true)) {
        _model.featured = HaatAuthGroup.marketplaceCall
            .featured(
              (_model.marketplaceResult?.jsonBody ?? ''),
            )!
            .toList()
            .cast<dynamic>();
        _model.billers = HaatAuthGroup.marketplaceCall
            .billers(
              (_model.marketplaceResult?.jsonBody ?? ''),
            )!
            .toList()
            .cast<dynamic>();
        _model.brands = HaatAuthGroup.marketplaceCall
            .brands(
              (_model.marketplaceResult?.jsonBody ?? ''),
            )!
            .toList()
            .cast<dynamic>();
        _model.categories = HaatAuthGroup.marketplaceCall
            .categories(
              (_model.marketplaceResult?.jsonBody ?? ''),
            )!
            .toList()
            .cast<dynamic>();
        safeSetState(() {});
      }
      if ((_model.bannersResult?.succeeded ?? true)) {
        _model.banners = HaatAuthGroup.marketplaceBannersCall
            .banners(
              (_model.bannersResult?.jsonBody ?? ''),
            )!
            .toList()
            .cast<dynamic>();
        safeSetState(() {});
      }
    });
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Color(0xFFF4F4F4),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: _model.banners.length == 0 ? 200.0 : 492.0,
                      decoration: BoxDecoration(),
                      child: Container(
                        width: double.infinity,
                        height: 492.0,
                        child: custom_widgets.MarketplaceBannerSlider(
                          width: double.infinity,
                          height: 492.0,
                          imagePath: '\$.imagePath',
                          logoPath: '\$.logoPath',
                          titlePath: '\$.title',
                          buttonPath: '\$.ctaLabel',
                          linkPath: '\$.actionUrl',
                          routePath: '\$.actionRoute',
                          contentBottomPadding: 56.0,
                          autoPlay: true,
                          banners: _model.banners,
                        ),
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              10.0, 67.0, 10.0, 0.0),
                          child: Container(
                            decoration: BoxDecoration(),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Text(
                                      'HAAT Marketplace',
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
                                            fontSize: 34.0,
                                            letterSpacing: 0.0,
                                            fontWeight: FontWeight.w500,
                                            fontStyle:
                                                FlutterFlowTheme.of(context)
                                                    .bodyMedium
                                                    .fontStyle,
                                          ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 14.0, 0.0, 0.0),
                                  child: InkWell(
                                    splashColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    onTap: () async {
                                      await showModalBottomSheet(
                                        isScrollControlled: true,
                                        backgroundColor: Colors.transparent,
                                        enableDrag: false,
                                        context: context,
                                        builder: (context) {
                                          return Padding(
                                            padding: MediaQuery.viewInsetsOf(
                                                context),
                                            child: MarketSpaceWidget(
                                              billers: _model.billers,
                                              brands: _model.brands,
                                              categories: _model.categories,
                                              focusSearch: true,
                                            ),
                                          );
                                        },
                                      ).then((value) => safeSetState(() {}));
                                    },
                                    child: Container(
                                      width: double.infinity,
                                      height: 43.0,
                                      decoration: BoxDecoration(
                                        color: Color(0x5DF5F5F7),
                                        borderRadius:
                                            BorderRadius.circular(29.0),
                                        border: Border.all(
                                          color: FlutterFlowTheme.of(context)
                                              .primaryText,
                                          width: 1.0,
                                        ),
                                      ),
                                      alignment:
                                          AlignmentDirectional(-1.0, 0.0),
                                      child: Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            21.0, 0.0, 16.0, 0.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Icon(
                                              Icons.search_rounded,
                                              color: Color(0xFF707171),
                                              size: 16.0,
                                            ),
                                            Text(
                                              'Search ',
                                              style: FlutterFlowTheme.of(
                                                      context)
                                                  .labelMedium
                                                  .override(
                                                    font:
                                                        GoogleFonts.montserrat(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                  context)
                                                              .labelMedium
                                                              .fontStyle,
                                                    ),
                                                    color: FlutterFlowTheme.of(
                                                            context)
                                                        .primaryText,
                                                    letterSpacing: 0.0,
                                                    fontWeight: FontWeight.w500,
                                                    fontStyle:
                                                        FlutterFlowTheme.of(
                                                                context)
                                                            .labelMedium
                                                            .fontStyle,
                                                  ),
                                            ),
                                          ].divide(SizedBox(width: 16.0)),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              12.0,
                              valueOrDefault<double>(
                                _model.banners.length == 0 ? 40.0 : 300.0,
                                0.0,
                              ),
                              12.0,
                              110.0),
                          child: Container(
                            width: 100.0,
                            constraints: BoxConstraints(
                              minWidth: double.infinity,
                            ),
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  decoration: BoxDecoration(),
                                  child: Visibility(
                                    visible: _model.featured.isNotEmpty,
                                    child: Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0.0, 10.0, 0.0, 0.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            (FFCrossAxisAlignment.start)
                                                .flutterValue,
                                        textBaseline: TextBaseline.alphabetic,
                                        children: [
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10.0, 0.0, 10.0, 0.0),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  (FFMainAxisAlignment
                                                          .spaceBetween)
                                                      .flutterValue,
                                              children: [
                                                Text(
                                                  'Picked For You',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .montserrat(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color: FlutterFlowTheme
                                                                .of(context)
                                                            .primaryBackground,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                InkWell(
                                                  splashColor:
                                                      Colors.transparent,
                                                  focusColor:
                                                      Colors.transparent,
                                                  hoverColor:
                                                      Colors.transparent,
                                                  highlightColor:
                                                      Colors.transparent,
                                                  onTap: () async {
                                                    await showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      enableDrag: false,
                                                      context: context,
                                                      builder: (context) {
                                                        return Padding(
                                                          padding: MediaQuery
                                                              .viewInsetsOf(
                                                                  context),
                                                          child:
                                                              MarketSpaceWidget(
                                                            billers:
                                                                _model.billers,
                                                            brands:
                                                                _model.brands,
                                                            categories: _model
                                                                .categories,
                                                          ),
                                                        );
                                                      },
                                                    ).then((value) =>
                                                        safeSetState(() {}));
                                                  },
                                                  child: Text(
                                                    'See all',
                                                    style: FlutterFlowTheme.of(
                                                            context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .montserrat(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .success,
                                                          fontSize: 11.0,
                                                          letterSpacing: 0.0,
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
                                              ],
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10.0, 12.0, 10.0, 0.0),
                                            child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Builder(
                                                    builder: (context) {
                                                      final featuredPage =
                                                          functions
                                                              .pageIndexes(
                                                                  _model
                                                                      .featured
                                                                      .length,
                                                                  8)
                                                              .toList();

                                                      return Container(
                                                        width: double.infinity,
                                                        height: _model.featured
                                                                    .length >
                                                                4
                                                            ? 176.0
                                                            : 80.0,
                                                        child: PageView.builder(
                                                          controller: _model
                                                                  .pageViewController ??=
                                                              PageController(
                                                                  initialPage: max(
                                                                      0,
                                                                      min(
                                                                          0,
                                                                          featuredPage.length -
                                                                              1))),
                                                          onPageChanged: (_) =>
                                                              safeSetState(
                                                                  () {}),
                                                          scrollDirection:
                                                              Axis.horizontal,
                                                          itemCount:
                                                              featuredPage
                                                                  .length,
                                                          itemBuilder: (context,
                                                              featuredPageIndex) {
                                                            final featuredPageItem =
                                                                featuredPage[
                                                                    featuredPageIndex];
                                                            return Builder(
                                                              builder:
                                                                  (context) {
                                                                final featuredItem = functions
                                                                    .pageItems(
                                                                        _model
                                                                            .featured
                                                                            .toList(),
                                                                        featuredPageItem,
                                                                        8)
                                                                    .toList();

                                                                return Wrap(
                                                                  spacing: 10.0,
                                                                  runSpacing:
                                                                      16.0,
                                                                  alignment:
                                                                      WrapAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      WrapCrossAlignment
                                                                          .start,
                                                                  direction: Axis
                                                                      .horizontal,
                                                                  runAlignment:
                                                                      WrapAlignment
                                                                          .start,
                                                                  verticalDirection:
                                                                      VerticalDirection
                                                                          .down,
                                                                  clipBehavior:
                                                                      Clip.none,
                                                                  children: List.generate(
                                                                      featuredItem
                                                                          .length,
                                                                      (featuredItemIndex) {
                                                                    final featuredItemItem =
                                                                        featuredItem[
                                                                            featuredItemIndex];
                                                                    return MarketBillerTileWidget(
                                                                      key: Key(
                                                                          'Key279_${featuredItemIndex}_of_${featuredItem.length}'),
                                                                      name: functions.notificationText(
                                                                          featuredItemItem,
                                                                          'name',
                                                                          FFAppState()
                                                                              .languageCode)!,
                                                                      logoUrl: functions.bannerImageUrl(
                                                                          getJsonField(
                                                                            featuredItemItem,
                                                                            r'''$.logoPath''',
                                                                          ).toString(),
                                                                          FFDevEnvironmentValues().baseURL),
                                                                      width: functions.shareOfWidth(
                                                                          MediaQuery.sizeOf(context)
                                                                              .width,
                                                                          44.0,
                                                                          4.0,
                                                                          10.0),
                                                                      onTap:
                                                                          () async {
                                                                        await actions
                                                                            .openMarketplaceItem(
                                                                          context,
                                                                          featuredItemItem,
                                                                          FFAppState()
                                                                              .languageCode,
                                                                        );
                                                                      },
                                                                    );
                                                                  }),
                                                                );
                                                              },
                                                            );
                                                          },
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  Padding(
                                                    padding:
                                                        EdgeInsetsDirectional
                                                            .fromSTEB(0.0, 12.0,
                                                                0.0, 0.0),
                                                    child: Builder(
                                                      builder: (context) {
                                                        final dot = functions
                                                            .pageIndexes(
                                                                _model.featured
                                                                    .length,
                                                                8)
                                                            .toList();

                                                        return Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              (FFMainAxisAlignment
                                                                      .center)
                                                                  .flutterValue,
                                                          children:
                                                              List.generate(
                                                                  dot.length,
                                                                  (dotIndex) {
                                                            final dotItem =
                                                                dot[dotIndex];
                                                            return Container(
                                                              width: 5.0,
                                                              height: 5.0,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: dotItem ==
                                                                        _model
                                                                            .pageViewCurrentIndex
                                                                    ? FlutterFlowTheme.of(
                                                                            context)
                                                                        .primaryBackground
                                                                    : Color(
                                                                        0xFFC4C4C4),
                                                              ),
                                                            );
                                                          }).divide(SizedBox(
                                                                  width: 4.0)),
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    0.0, 20.0, 0.0, 0.0),
                                            child: Container(
                                              width: double.infinity,
                                              height: 4.0,
                                              decoration: BoxDecoration(
                                                color:
                                                    FlutterFlowTheme.of(context)
                                                        .secondaryBackground,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 20.0, 0.0, 20.0),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          (FFCrossAxisAlignment.start)
                                              .flutterValue,
                                      textBaseline: TextBaseline.alphabetic,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  10.0, 0.0, 10.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                (FFMainAxisAlignment
                                                        .spaceBetween)
                                                    .flutterValue,
                                            children: [
                                              Text(
                                                'Categories',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .montserrat(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(),
                                          child: Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                    10.0, 10.0, 10.0, 0.0),
                                            child: Builder(
                                              builder: (context) {
                                                final category =
                                                    _model.categories.toList();

                                                return Wrap(
                                                  spacing: 10.0,
                                                  runSpacing: 10.0,
                                                  alignment:
                                                      WrapAlignment.start,
                                                  crossAxisAlignment:
                                                      WrapCrossAlignment.start,
                                                  direction: Axis.horizontal,
                                                  runAlignment:
                                                      WrapAlignment.start,
                                                  verticalDirection:
                                                      VerticalDirection.down,
                                                  clipBehavior: Clip.none,
                                                  children: List.generate(
                                                      category.length,
                                                      (categoryIndex) {
                                                    final categoryItem =
                                                        category[categoryIndex];
                                                    return MarketCategoryTileWidget(
                                                      key: Key(
                                                          'Keygbr_${categoryIndex}_of_${category.length}'),
                                                      categoryKey: getJsonField(
                                                        categoryItem,
                                                        r'''$.key''',
                                                      ).toString(),
                                                      label: functions
                                                          .notificationText(
                                                              categoryItem,
                                                              'label',
                                                              FFAppState()
                                                                  .languageCode),
                                                      width: functions
                                                          .shareOfWidth(
                                                              MediaQuery.sizeOf(
                                                                      context)
                                                                  .width,
                                                              44.0,
                                                              2.0,
                                                              10.0),
                                                      onTap: () async {
                                                        await showModalBottomSheet(
                                                          isScrollControlled:
                                                              true,
                                                          backgroundColor:
                                                              Colors
                                                                  .transparent,
                                                          enableDrag: false,
                                                          context: context,
                                                          builder: (context) {
                                                            return Padding(
                                                              padding: MediaQuery
                                                                  .viewInsetsOf(
                                                                      context),
                                                              child:
                                                                  MarketSpaceWidget(
                                                                billers: _model
                                                                    .billers,
                                                                brands: _model
                                                                    .brands,
                                                                categories: _model
                                                                    .categories,
                                                                initialCategory:
                                                                    getJsonField(
                                                                  categoryItem,
                                                                  r'''$.key''',
                                                                ).toString(),
                                                              ),
                                                            );
                                                          },
                                                        ).then((value) =>
                                                            safeSetState(
                                                                () {}));
                                                      },
                                                    );
                                                  }),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  0.0, 20.0, 0.0, 0.0),
                                          child: Container(
                                            width: double.infinity,
                                            height: 4.0,
                                            decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .secondaryBackground,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 20.0),
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  10.0, 0.0, 10.0, 0.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                (FFMainAxisAlignment
                                                        .spaceBetween)
                                                    .flutterValue,
                                            children: [
                                              Text(
                                                'Explore Top Brands',
                                                style:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .override(
                                                          font: GoogleFonts
                                                              .montserrat(
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                        context)
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color: FlutterFlowTheme
                                                                  .of(context)
                                                              .primaryBackground,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                              ),
                                              InkWell(
                                                splashColor: Colors.transparent,
                                                focusColor: Colors.transparent,
                                                hoverColor: Colors.transparent,
                                                highlightColor:
                                                    Colors.transparent,
                                                onTap: () async {
                                                  await showModalBottomSheet(
                                                    isScrollControlled: true,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    enableDrag: false,
                                                    context: context,
                                                    builder: (context) {
                                                      return Padding(
                                                        padding: MediaQuery
                                                            .viewInsetsOf(
                                                                context),
                                                        child:
                                                            MarketSpaceWidget(
                                                          billers:
                                                              _model.billers,
                                                          brands: _model.brands,
                                                          categories:
                                                              _model.categories,
                                                        ),
                                                      );
                                                    },
                                                  ).then((value) =>
                                                      safeSetState(() {}));
                                                },
                                                child: Text(
                                                  'See all',
                                                  style: FlutterFlowTheme.of(
                                                          context)
                                                      .bodyMedium
                                                      .override(
                                                        font: GoogleFonts
                                                            .montserrat(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                      context)
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                                    context)
                                                                .success,
                                                        fontSize: 11.0,
                                                        letterSpacing: 0.0,
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
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              EdgeInsetsDirectional.fromSTEB(
                                                  10.0, 10.0, 10.0, 0.0),
                                          child: Builder(
                                            builder: (context) {
                                              final brand =
                                                  _model.brands.toList();

                                              return SingleChildScrollView(
                                                scrollDirection:
                                                    Axis.horizontal,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: List.generate(
                                                      brand.length,
                                                      (brandIndex) {
                                                    final brandItem =
                                                        brand[brandIndex];
                                                    return MarketBrandCardWidget(
                                                      key: Key(
                                                          'Keygg3_${brandIndex}_of_${brand.length}'),
                                                      name: functions
                                                          .notificationText(
                                                              brandItem,
                                                              'name',
                                                              FFAppState()
                                                                  .languageCode),
                                                      description: functions
                                                          .notificationText(
                                                              brandItem,
                                                              'description',
                                                              FFAppState()
                                                                  .languageCode),
                                                      logoUrl: functions
                                                          .bannerImageUrl(
                                                              getJsonField(
                                                                brandItem,
                                                                r'''$.logoPath''',
                                                              ).toString(),
                                                              FFDevEnvironmentValues()
                                                                  .baseURL),
                                                      coverUrl: functions
                                                          .bannerImageUrl(
                                                              getJsonField(
                                                                brandItem,
                                                                r'''$.coverPath''',
                                                              ).toString(),
                                                              FFDevEnvironmentValues()
                                                                  .baseURL),
                                                      width: functions
                                                          .shareOfWidth(
                                                              MediaQuery.sizeOf(
                                                                      context)
                                                                  .width,
                                                              44.0,
                                                              2.35,
                                                              0.0),
                                                      onTap: () async {
                                                        await actions
                                                            .openMarketplaceItem(
                                                          context,
                                                          brandItem,
                                                          FFAppState()
                                                              .languageCode,
                                                        );
                                                      },
                                                    );
                                                  }).divide(
                                                      SizedBox(width: 10.0)),
                                                ),
                                              );
                                            },
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
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
