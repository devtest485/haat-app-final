import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'market_category_tile_model.dart';
export 'market_category_tile_model.dart';

class MarketCategoryTileWidget extends StatefulWidget {
  const MarketCategoryTileWidget({
    super.key,
    String? categoryKey,
    this.label,
    double? width,
    this.onTap,
  })  : this.categoryKey = categoryKey ?? 'for_you',
        this.width = width ?? 160.0;

  final String categoryKey;
  final String? label;
  final double width;
  final Future Function()? onTap;

  @override
  State<MarketCategoryTileWidget> createState() =>
      _MarketCategoryTileWidgetState();
}

class _MarketCategoryTileWidgetState extends State<MarketCategoryTileWidget> {
  late MarketCategoryTileModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MarketCategoryTileModel());
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
        width: widget!.width,
        height: 50.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10.0, 0.0, 10.0, 0.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: (FFMainAxisAlignment.start).flutterValue,
            children: [
              if (widget!.categoryKey == 'telecom')
                Icon(
                  Icons.cell_tower_rounded,
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  size: 19.0,
                ),
              if (widget!.categoryKey == 'utilities')
                Icon(
                  Icons.bolt_rounded,
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  size: 19.0,
                ),
              if (widget!.categoryKey == 'government')
                Icon(
                  Icons.account_balance_outlined,
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  size: 19.0,
                ),
              if (widget!.categoryKey == 'travel')
                Icon(
                  Icons.directions_car_outlined,
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  size: 19.0,
                ),
              if (widget!.categoryKey == 'education')
                Icon(
                  Icons.school_outlined,
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  size: 19.0,
                ),
              if (widget!.categoryKey == 'gift_cards')
                Icon(
                  Icons.card_giftcard_rounded,
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  size: 19.0,
                ),
              if (widget!.categoryKey == 'esim')
                Icon(
                  Icons.sim_card_outlined,
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  size: 19.0,
                ),
              if (widget!.categoryKey == 'shopping')
                Icon(
                  Icons.shopping_bag_outlined,
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  size: 19.0,
                ),
              if (widget!.categoryKey == 'international')
                Icon(
                  Icons.public_rounded,
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  size: 19.0,
                ),
              if ((widget!.categoryKey != 'telecom') &&
                  (widget!.categoryKey != 'utilities') &&
                  (widget!.categoryKey != 'government') &&
                  ((widget!.categoryKey != 'travel') &&
                      (widget!.categoryKey != 'education') &&
                      (widget!.categoryKey != 'gift_cards') &&
                      ((widget!.categoryKey != 'esim') &&
                          (widget!.categoryKey != 'shopping') &&
                          (widget!.categoryKey != 'international'))))
                Icon(
                  Icons.star_border,
                  color: FlutterFlowTheme.of(context).primaryBackground,
                  size: 19.0,
                ),
              Expanded(
                child: Text(
                  widget!.label!,
                  maxLines: 1,
                  style: FlutterFlowTheme.of(context).bodyMedium.override(
                        font: GoogleFonts.inter(
                          fontWeight: FontWeight.w500,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                        color: FlutterFlowTheme.of(context).primaryBackground,
                        letterSpacing: 0.0,
                        fontWeight: FontWeight.w500,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ].divide(SizedBox(width: 12.0)),
          ),
        ),
      ),
    );
  }
}
