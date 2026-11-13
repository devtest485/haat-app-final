import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'marketplace_shimmer_model.dart';
export 'marketplace_shimmer_model.dart';

/// Marketplace placeholder while the catalogue loads: Picked For You tiles,
/// Categories and Top Brands, sized like the real sections.
class MarketplaceShimmerWidget extends StatefulWidget {
  const MarketplaceShimmerWidget({super.key});

  @override
  State<MarketplaceShimmerWidget> createState() =>
      _MarketplaceShimmerWidgetState();
}

class _MarketplaceShimmerWidgetState extends State<MarketplaceShimmerWidget>
    with TickerProviderStateMixin {
  late MarketplaceShimmerModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MarketplaceShimmerModel());

    animationsMap.addAll({
      'columnOnPageLoadAnimation': AnimationInfo(
        loop: true,
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          ShimmerEffect(
            curve: Curves.easeInOut,
            delay: 0.0.ms,
            duration: 1200.0.ms,
            color: Color(0xFFF7F7F7),
            angle: 0,
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: (FFCrossAxisAlignment.start).flutterValue,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10.0, 12.0, 10.0, 0.0),
          child: Container(
            width: 120.0,
            height: 14.0,
            decoration: BoxDecoration(
              color: Color(0xFFE6E6E6),
              borderRadius: BorderRadius.circular(7.0),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10.0, 16.0, 10.0, 0.0),
          child: Builder(
            builder: (context) {
              final tileRow = functions.pageIndexes(2, 1).toList();

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(tileRow.length, (tileRowIndex) {
                  final tileRowItem = tileRow[tileRowIndex];
                  return Builder(
                    builder: (context) {
                      final tile = functions.pageIndexes(4, 1).toList();

                      return Row(
                        mainAxisSize: MainAxisSize.max,
                        children: List.generate(tile.length, (tileIndex) {
                          final tileItem = tile[tileIndex];
                          return Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 55.0,
                                  height: 55.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFE6E6E6),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Container(
                                  width: 44.0,
                                  height: 10.0,
                                  decoration: BoxDecoration(
                                    color: Color(0xFFE6E6E6),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                ),
                              ].divide(SizedBox(height: 8.0)),
                            ),
                          );
                        }).divide(SizedBox(width: 10.0)),
                      );
                    },
                  );
                }).divide(SizedBox(height: 16.0)),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 24.0, 0.0, 0.0),
          child: Container(
            width: double.infinity,
            height: 4.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10.0, 20.0, 10.0, 0.0),
          child: Container(
            width: 96.0,
            height: 14.0,
            decoration: BoxDecoration(
              color: Color(0xFFE6E6E6),
              borderRadius: BorderRadius.circular(7.0),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10.0, 12.0, 10.0, 0.0),
          child: Builder(
            builder: (context) {
              final categoryRow = functions.pageIndexes(2, 1).toList();

              return Column(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(categoryRow.length, (categoryRowIndex) {
                  final categoryRowItem = categoryRow[categoryRowIndex];
                  return Builder(
                    builder: (context) {
                      final category = functions.pageIndexes(2, 1).toList();

                      return Row(
                        mainAxisSize: MainAxisSize.max,
                        children:
                            List.generate(category.length, (categoryIndex) {
                          final categoryItem = category[categoryIndex];
                          return Expanded(
                            child: Container(
                              height: 44.0,
                              decoration: BoxDecoration(
                                color: Color(0xFFE6E6E6),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                            ),
                          );
                        }).divide(SizedBox(width: 10.0)),
                      );
                    },
                  );
                }).divide(SizedBox(height: 10.0)),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
          child: Container(
            width: double.infinity,
            height: 4.0,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10.0, 20.0, 10.0, 0.0),
          child: Container(
            width: 140.0,
            height: 14.0,
            decoration: BoxDecoration(
              color: Color(0xFFE6E6E6),
              borderRadius: BorderRadius.circular(7.0),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10.0, 12.0, 10.0, 20.0),
          child: Builder(
            builder: (context) {
              final brand = functions.pageIndexes(2, 1).toList();

              return Row(
                mainAxisSize: MainAxisSize.max,
                children: List.generate(brand.length, (brandIndex) {
                  final brandItem = brand[brandIndex];
                  return Expanded(
                    child: Container(
                      height: 150.0,
                      decoration: BoxDecoration(
                        color: Color(0xFFE6E6E6),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                  );
                }).divide(SizedBox(width: 10.0)),
              );
            },
          ),
        ),
      ],
    ).animateOnPageLoad(animationsMap['columnOnPageLoadAnimation']!);
  }
}
