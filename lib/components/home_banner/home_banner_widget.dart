import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_banner_model.dart';
export 'home_banner_model.dart';

class HomeBannerWidget extends StatefulWidget {
  const HomeBannerWidget({super.key});

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
    return Container(
      width: double.infinity,
      height: 107.0,
      decoration: BoxDecoration(),
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
                  ClipRRect(
                    borderRadius: BorderRadius.only(),
                    child: SvgPicture.asset(
                      'assets/images/hattLogo.svg',
                      width: 52.0,
                      height: 18.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Text(
                        'Verify Your Business ',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
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
                      ),
                      Padding(
                        padding:
                            EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 8.0),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment:
                              (FFMainAxisAlignment.start).flutterValue,
                          children: [
                            Container(
                              width: 5.0,
                              height: 5.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context).primaryText,
                              ),
                            ),
                            Container(
                              width: 5.0,
                              height: 5.0,
                              decoration: BoxDecoration(
                                color: Color(0x33FFFFFF),
                              ),
                            ),
                            Container(
                              width: 5.0,
                              height: 5.0,
                              decoration: BoxDecoration(
                                color: Color(0x33FFFFFF),
                              ),
                            ),
                          ].divide(SizedBox(width: 4.0)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ClipRRect(
            borderRadius: BorderRadius.only(),
            child: Image.network(
              'https://picsum.photos/seed/418/600',
              width: 99.0,
              height: 111.0,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}
