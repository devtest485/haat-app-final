import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'branch_shimmer_model.dart';
export 'branch_shimmer_model.dart';

/// Placeholder branch cards, shimmering while the branches load.
///
/// Same cards as the Branches page.
class BranchShimmerWidget extends StatefulWidget {
  const BranchShimmerWidget({super.key});

  @override
  State<BranchShimmerWidget> createState() => _BranchShimmerWidgetState();
}

class _BranchShimmerWidgetState extends State<BranchShimmerWidget>
    with TickerProviderStateMixin {
  late BranchShimmerModel _model;

  final animationsMap = <String, AnimationInfo>{};

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BranchShimmerModel());

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
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: (FFCrossAxisAlignment.start).flutterValue,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(5.0, 8.0, 5.0, 8.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryText,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: 74.0,
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment:
                          (FFCrossAxisAlignment.center).flutterValue,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Container(
                          width: 32.0,
                          height: 32.0,
                          decoration: BoxDecoration(
                            color: Color(0xFFE6E6E6),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment:
                                (FFCrossAxisAlignment.start).flutterValue,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Container(
                                width: 120.0,
                                height: 13.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFFE6E6E6),
                                  borderRadius: BorderRadius.circular(6.5),
                                ),
                              ),
                              Container(
                                width: 160.0,
                                height: 11.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFFE6E6E6),
                                  borderRadius: BorderRadius.circular(5.5),
                                ),
                              ),
                            ].divide(SizedBox(height: 6.0)),
                          ),
                        ),
                        Container(
                          width: 8.0,
                          height: 14.0,
                          decoration: BoxDecoration(
                            color: Color(0xFFE6E6E6),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                      ].divide(SizedBox(width: 12.0)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(5.0, 8.0, 5.0, 8.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryText,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: 74.0,
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment:
                          (FFCrossAxisAlignment.center).flutterValue,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Container(
                          width: 32.0,
                          height: 32.0,
                          decoration: BoxDecoration(
                            color: Color(0xFFE6E6E6),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment:
                                (FFCrossAxisAlignment.start).flutterValue,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Container(
                                width: 96.0,
                                height: 13.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFFE6E6E6),
                                  borderRadius: BorderRadius.circular(6.5),
                                ),
                              ),
                              Container(
                                width: 140.0,
                                height: 11.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFFE6E6E6),
                                  borderRadius: BorderRadius.circular(5.5),
                                ),
                              ),
                            ].divide(SizedBox(height: 6.0)),
                          ),
                        ),
                        Container(
                          width: 8.0,
                          height: 14.0,
                          decoration: BoxDecoration(
                            color: Color(0xFFE6E6E6),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                      ].divide(SizedBox(width: 12.0)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(5.0, 8.0, 5.0, 8.0),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).primaryText,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  height: 74.0,
                  child: Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(8.0, 8.0, 8.0, 8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment:
                          (FFCrossAxisAlignment.center).flutterValue,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Container(
                          width: 32.0,
                          height: 32.0,
                          decoration: BoxDecoration(
                            color: Color(0xFFE6E6E6),
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment:
                                (FFCrossAxisAlignment.start).flutterValue,
                            textBaseline: TextBaseline.alphabetic,
                            children: [
                              Container(
                                width: 136.0,
                                height: 13.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFFE6E6E6),
                                  borderRadius: BorderRadius.circular(6.5),
                                ),
                              ),
                              Container(
                                width: 120.0,
                                height: 11.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFFE6E6E6),
                                  borderRadius: BorderRadius.circular(5.5),
                                ),
                              ),
                            ].divide(SizedBox(height: 6.0)),
                          ),
                        ),
                        Container(
                          width: 8.0,
                          height: 14.0,
                          decoration: BoxDecoration(
                            color: Color(0xFFE6E6E6),
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                      ].divide(SizedBox(width: 12.0)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ].divide(SizedBox(height: 10.0)),
    ).animateOnPageLoad(animationsMap['columnOnPageLoadAnimation']!);
  }
}
