import '/components/market_biller_row/market_biller_row_widget.dart';
import '/components/market_brand_card/market_brand_card_widget.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'market_space_model.dart';
export 'market_space_model.dart';

/// Every biller, behind "See all" and the category tiles on the Marketplace tab.
///
/// The tab hands over what it already fetched, so the sheet opens without a second
/// call. A chip narrows the list to one category (`for_you` is the featured ones), and
/// the search box to the names that match.
class MarketSpaceWidget extends StatefulWidget {
  const MarketSpaceWidget({
    super.key,
    String? initialCategory,
    List<dynamic>? billers,
    List<dynamic>? brands,
    List<dynamic>? categories,
  })  : this.initialCategory = initialCategory ?? '',
        this.billers = billers ?? const [],
        this.brands = brands ?? const [],
        this.categories = categories ?? const [];

  /// The chip chosen when the sheet opens: a category key, `for_you`, or empty for
  /// every biller.
  final String initialCategory;
  final List<dynamic> billers;
  final List<dynamic> brands;
  final List<dynamic> categories;

  @override
  State<MarketSpaceWidget> createState() => _MarketSpaceWidgetState();
}

class _MarketSpaceWidgetState extends State<MarketSpaceWidget> {
  late MarketSpaceModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MarketSpaceModel());

    // On component load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.selectedCategory = widget.initialCategory;
      safeSetState(() {});
    });

    _model.textController ??= TextEditingController();
    _model.textFieldFocusNode ??= FocusNode();
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
        color: FlutterFlowTheme.of(context).primaryText,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(12.0, 67.0, 12.0, 0.0),
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
                    color: FlutterFlowTheme.of(context).primaryBackground,
                    size: 24.0,
                  ),
                ),
                Container(
                  width: MediaQuery.sizeOf(context).width * 0.854,
                  height: 48.0,
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).primaryText,
                    boxShadow: [
                      FlutterFlowTheme.of(context).designToken.shadow.sm
                    ],
                    borderRadius: BorderRadius.circular(29.0),
                    border: Border.all(
                      color: Color(0x2D000000),
                      width: 0.5,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(7.0, 5.0, 5.0, 0.0),
                    child: Container(
                      width: 200.0,
                      child: TextFormField(
                        controller: _model.textController,
                        focusNode: _model.textFieldFocusNode,
                        onChanged: (_) => EasyDebounce.debounce(
                          '_model.textController',
                          Duration(milliseconds: 300),
                          () => safeSetState(() {}),
                        ),
                        autofocus: false,
                        enabled: true,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: true,
                          labelStyle:
                              FlutterFlowTheme.of(context).labelMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                          hintText: 'Search ',
                          hintStyle:
                              FlutterFlowTheme.of(context).labelMedium.override(
                                    font: GoogleFonts.inter(
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .labelMedium
                                          .fontStyle,
                                    ),
                                    letterSpacing: 0.0,
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .labelMedium
                                        .fontStyle,
                                  ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(24.0),
                          ),
                          filled: true,
                          fillColor: FlutterFlowTheme.of(context).primaryText,
                          suffixIcon: Icon(
                            Icons.search_sharp,
                            color: Color(0xFF707171),
                            size: 24.0,
                          ),
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                        cursorColor: FlutterFlowTheme.of(context).primaryText,
                        enableInteractiveSelection: true,
                        validator:
                            _model.textControllerValidator.asValidator(context),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(10.0, 20.0, 0.0, 0.0),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(),
              child: Builder(
                builder: (context) {
                  final category = widget.categories.toList();

                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: List.generate(category.length, (categoryIndex) {
                        final categoryItem = category[categoryIndex];
                        return InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            if (_model.selectedCategory ==
                                getJsonField(
                                  categoryItem,
                                  r'''$.key''',
                                ).toString()) {
                              _model.selectedCategory = '';
                            } else {
                              _model.selectedCategory = getJsonField(
                                categoryItem,
                                r'''$.key''',
                              ).toString();
                            }
                            safeSetState(() {});
                          },
                          child: Container(
                            height: 35.0,
                            decoration: BoxDecoration(
                              color: _model.selectedCategory ==
                                      getJsonField(
                                        categoryItem,
                                        r'''$.key''',
                                      ).toString()
                                  ? FlutterFlowTheme.of(context)
                                      .primaryBackground
                                  : FlutterFlowTheme.of(context)
                                      .secondaryBackground,
                              borderRadius: BorderRadius.circular(50.0),
                              border: Border.all(
                                color: _model.selectedCategory ==
                                        getJsonField(
                                          categoryItem,
                                          r'''$.key''',
                                        ).toString()
                                    ? FlutterFlowTheme.of(context)
                                        .primaryBackground
                                    : Color(0x85262D34),
                                width: 1.0,
                              ),
                            ),
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  14.0, 0.0, 14.0, 0.0),
                              child: Text(
                                functions.notificationText(categoryItem,
                                    'label', FFAppState().languageCode),
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: _model.selectedCategory ==
                                              getJsonField(
                                                categoryItem,
                                                r'''$.key''',
                                              ).toString()
                                          ? FlutterFlowTheme.of(context)
                                              .primaryText
                                          : FlutterFlowTheme.of(context)
                                              .primaryBackground,
                                      fontSize: 12.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                            ),
                          ),
                        );
                      }).divide(SizedBox(width: 5.0)),
                    ),
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(15.0, 30.0, 15.0, 0.0),
                    child: Builder(
                      builder: (context) {
                        final biller = functions
                            .marketplaceItemsFor(
                                widget.billers,
                                _model.selectedCategory,
                                _model.textController.text)
                            .toList();
                        if (biller.isEmpty) {
                          return Container(
                            width: double.infinity,
                            decoration: BoxDecoration(),
                            child: Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 24.0, 0.0, 24.0),
                              child: Text(
                                'No billers match. Try another name or category.',
                                textAlign: TextAlign.center,
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.inter(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      color: Color(0x85000000),
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                            ),
                          );
                        }

                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          children: List.generate(biller.length, (billerIndex) {
                            final billerItem = biller[billerIndex];
                            return MarketBillerRowWidget(
                              key: Key(
                                  'Keymbr_${billerIndex}_of_${biller.length}'),
                              name: functions.notificationText(billerItem,
                                  'name', FFAppState().languageCode),
                              description: functions.notificationText(
                                  billerItem,
                                  'description',
                                  FFAppState().languageCode),
                              logoUrl: functions.bannerImageUrl(
                                  getJsonField(
                                    billerItem,
                                    r'''$.logoPath''',
                                  )?.toString(),
                                  FFDevEnvironmentValues().baseURL),
                              onTap: () async {
                                await actions.openMarketplaceItem(
                                  context,
                                  billerItem,
                                  FFAppState().languageCode,
                                );
                              },
                            );
                          }).divide(SizedBox(height: 20.0)),
                        );
                      },
                    ),
                  ),
                  if (functions
                      .marketplaceItemsFor(
                          widget.brands, '', _model.textController.text)
                      .isNotEmpty)
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(5.0, 30.0, 0.0, 30.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment:
                            (FFCrossAxisAlignment.start).flutterValue,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 0.0, 10.0, 0.0),
                            child: Text(
                              'Explore Top Brands',
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
                                10.0, 10.0, 0.0, 0.0),
                            child: Builder(
                              builder: (context) {
                                final brand = functions
                                    .marketplaceItemsFor(widget.brands, '',
                                        _model.textController.text)
                                    .toList();

                                return SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        (FFCrossAxisAlignment.start)
                                            .flutterValue,
                                    children: List.generate(brand.length,
                                        (brandIndex) {
                                      final brandItem = brand[brandIndex];
                                      return MarketBrandCardWidget(
                                        key: Key(
                                            'Keymbs_${brandIndex}_of_${brand.length}'),
                                        name: functions.notificationText(
                                            brandItem,
                                            'name',
                                            FFAppState().languageCode),
                                        description: functions.notificationText(
                                            brandItem,
                                            'description',
                                            FFAppState().languageCode),
                                        logoUrl: functions.bannerImageUrl(
                                            getJsonField(
                                              brandItem,
                                              r'''$.logoPath''',
                                            )?.toString(),
                                            FFDevEnvironmentValues().baseURL),
                                        coverUrl: functions.bannerImageUrl(
                                            getJsonField(
                                              brandItem,
                                              r'''$.coverPath''',
                                            )?.toString(),
                                            FFDevEnvironmentValues().baseURL),
                                        onTap: () async {
                                          await actions.openMarketplaceItem(
                                            context,
                                            brandItem,
                                            FFAppState().languageCode,
                                          );
                                        },
                                      );
                                    }).divide(SizedBox(width: 10.0)),
                                  ),
                                );
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
        ],
      ),
    );
  }
}
