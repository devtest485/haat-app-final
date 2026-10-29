import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_banner_model.dart';
export 'home_banner_model.dart';

class HomeBannerWidget extends StatefulWidget {
  const HomeBannerWidget({
    super.key,
    this.backgroundColor,
    this.title,
    this.imageUrl,
    int? dotCount,
    int? activeIndex,
    required this.onTap,
  })  : this.dotCount = dotCount ?? 1,
        this.activeIndex = activeIndex ?? 0;

  final Color? backgroundColor;
  final String? title;
  final String? imageUrl;
  final int dotCount;
  final int activeIndex;
  final Future Function()? onTap;

  @override
  State<HomeBannerWidget> createState() => _HomeBannerWidgetState();
}

class _HomeBannerWidgetState extends State<HomeBannerWidget> {
  late HomeBannerModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomeBannerModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      focusColor: Colors.transparent,
      hoverColor: Colors.transparent,
      highlightColor: Colors.transparent,
      onTap: () async {
        await widget.onTap?.call();
      },
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: widget!.backgroundColor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: (FFMainAxisAlignment.spaceBetween).flutterValue,
          children: [
            Container(
              width: 159.46,
              decoration: BoxDecoration(),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(12.0, 6.0, 0.0, 0.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment:
                      (FFMainAxisAlignment.spaceBetween).flutterValue,
                  crossAxisAlignment: (FFCrossAxisAlignment.start).flutterValue,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    if (functions.bannerDarkText(widget!.backgroundColor) ==
                        false)
                      ClipRRect(
                        borderRadius: BorderRadius.only(),
                        child: SvgPicture.asset(
                          'assets/images/hattLogo.svg',
                          width: 52.0,
                          height: 18.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    if (functions.bannerDarkText(widget!.backgroundColor) ==
                        true)
                      ClipRRect(
                        borderRadius: BorderRadius.only(),
                        child: SvgPicture.asset(
                          'assets/images/hattLogoDark.svg',
                          width: 52.0,
                          height: 18.0,
                          fit: BoxFit.cover,
                        ),
                      ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment:
                            (FFCrossAxisAlignment.start).flutterValue,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            valueOrDefault<String>(
                              widget!.title,
                              '.',
                            ),
                            maxLines: 2,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.montserrat(
                                    fontWeight: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontWeight,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color: functions
                                      .bannerOnColor(widget!.backgroundColor),
                                  fontSize: 16.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                  lineHeight: 1.3,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                0.0, 8.0, 0.0, 8.0),
                            child: Builder(
                              builder: (context) {
                                final dot = functions
                                    .bannerDotIndexes(widget!.dotCount)
                                    .toList();

                                return Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      (FFMainAxisAlignment.start).flutterValue,
                                  children:
                                      List.generate(dot.length, (dotIndex) {
                                    final dotItem = dot[dotIndex];
                                    return Container(
                                      width: 5.0,
                                      height: 5.0,
                                      decoration: BoxDecoration(
                                        color: functions.bannerDotColor(
                                            widget!.backgroundColor,
                                            dotItem,
                                            widget!.activeIndex),
                                      ),
                                    );
                                  }).divide(SizedBox(width: 4.0)),
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
            if (widget!.imageUrl != null && widget!.imageUrl != '')
              ClipRRect(
                borderRadius: BorderRadius.only(),
                child: Image.network(
                  widget!.imageUrl!,
                  width: 99.0,
                  height: 111.0,
                  fit: BoxFit.contain,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
