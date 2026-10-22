import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'market_biller_tile_model.dart';
export 'market_biller_tile_model.dart';

/// One of the round "Picked For You" icons on the Marketplace tab.
///
/// The logo is the one uploaded from the back office; until there is one, the first
/// letter of the name stands in for it.
class MarketBillerTileWidget extends StatefulWidget {
  const MarketBillerTileWidget({
    super.key,
    String? name,
    String? logoUrl,
    double? width,
    this.onTap,
  })  : this.name = name ?? '',
        this.logoUrl = logoUrl ?? '',
        this.width = width ?? 80.0;

  final String name;
  final String logoUrl;
  final double width;
  final Future Function()? onTap;

  @override
  State<MarketBillerTileWidget> createState() => _MarketBillerTileWidgetState();
}

class _MarketBillerTileWidgetState extends State<MarketBillerTileWidget> {
  late MarketBillerTileModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MarketBillerTileModel());
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
        width: widget.width,
        decoration: BoxDecoration(),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 55.0,
              height: 55.0,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondaryBackground,
                shape: BoxShape.circle,
              ),
              alignment: AlignmentDirectional(0.0, 0.0),
              child: Stack(
                alignment: AlignmentDirectional(0.0, 0.0),
                children: [
                  if (widget.logoUrl == '')
                    Text(
                      functions.initialLetter(widget.name),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.inter(
                              fontWeight: FontWeight.w600,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            fontSize: 20.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w600,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  if (widget.logoUrl != '')
                    ClipRRect(
                      borderRadius: BorderRadius.circular(27.5),
                      child: Image.network(
                        widget.logoUrl,
                        width: 55.0,
                        height: 55.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(2.0, 5.0, 2.0, 0.0),
              child: Text(
                widget.name,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.inter(
                        fontWeight: FontWeight.w500,
                        fontStyle:
                            FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      fontSize: 12.0,
                      letterSpacing: 0.0,
                      fontWeight: FontWeight.w500,
                      fontStyle:
                          FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
