import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'transactions_model.dart';
export 'transactions_model.dart';

class TransactionsWidget extends StatefulWidget {
  const TransactionsWidget({
    super.key,
    String? title,
    this.subtitle,
    this.amount,
    bool? incoming,
    this.paymentMethod,
    this.showDivider,
    this.tone,
  })  : this.title = title ?? 'Transaction',
        this.incoming = incoming ?? true;

  final String title;
  final String? subtitle;
  final String? amount;
  final bool incoming;
  final String? paymentMethod;
  final bool? showDivider;

  /// `sent` or `received` for money between merchants — yellow and green — and
  /// empty for every other line.
  final String? tone;

  @override
  State<TransactionsWidget> createState() => _TransactionsWidgetState();
}

class _TransactionsWidgetState extends State<TransactionsWidget> {
  late TransactionsModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TransactionsModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  bool get _sent => widget.tone == 'sent';
  bool get _received => widget.tone == 'received';

  @override
  Widget build(BuildContext context) {
    final row = _row(context);
    if (!_sent && !_received) return row;

    // Money between merchants arrives with a small rise, so a new one is noticed.
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      builder: (context, t, child) => Opacity(
        opacity: t,
        child:
            Transform.translate(offset: Offset(0, 10 * (1 - t)), child: child),
      ),
      child: row,
    );
  }

  Widget _row(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsetsDirectional.fromSTEB(5.0, 8.0, 5.0, 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 32.0,
                  height: 32.0,
                  decoration: BoxDecoration(
                    color: _sent
                        ? Color(0xFFFFF5D6)
                        : _received
                            ? Color(0x1F00DA76)
                            : Color(0xFFF1F1F1),
                    shape: BoxShape.circle,
                  ),
                  alignment: AlignmentDirectional(0.0, 0.0),
                  child: Align(
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Stack(
                      alignment: AlignmentDirectional(0.0, 0.0),
                      children: [
                        if (widget!.incoming)
                          Icon(
                            Icons.south_west,
                            color: _received ? Color(0xFF00794A) : Colors.black,
                            size: 16.0,
                          ),
                        if (widget!.incoming == false)
                          Icon(
                            Icons.arrow_outward,
                            color: _sent ? Color(0xFF7A5600) : Colors.black,
                            size: 16.0,
                          ),
                        if ((widget!.paymentMethod == 'tap') ||
                            (widget!.paymentMethod == 'qr') ||
                            (widget!.paymentMethod == 'link'))
                          Align(
                            alignment: AlignmentDirectional(1.0, 1.0),
                            child: Container(
                              width: 14.0,
                              height: 14.0,
                              decoration: BoxDecoration(
                                color: Color(0xFFC1ECD8),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(40.0),
                                  topRight: Radius.circular(40.0),
                                  bottomLeft: Radius.circular(40.0),
                                  bottomRight: Radius.circular(40.0),
                                ),
                              ),
                              alignment: AlignmentDirectional(0.0, 0.0),
                              child: Align(
                                alignment: AlignmentDirectional(0.0, 0.0),
                                child: Stack(
                                  children: [
                                    if (widget!.paymentMethod == 'tap')
                                      Icon(
                                        Icons.contactless_outlined,
                                        color: Color(0xFF002011),
                                        size: 8.0,
                                      ),
                                    if (widget!.paymentMethod == 'qr')
                                      Icon(
                                        Icons.qr_code_2_rounded,
                                        color: Color(0xFF002011),
                                        size: 8.0,
                                      ),
                                    if (widget!.paymentMethod == 'link')
                                      Icon(
                                        Icons.link_rounded,
                                        color: Color(0xFF002011),
                                        size: 8.0,
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment:
                        (FFCrossAxisAlignment.start).flutterValue,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Expanded(
                            child: Text(
                              widget!.title,
                              maxLines: 1,
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: Color(0xFF111111),
                                    fontSize: 13.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                    lineHeight: 1.54,
                                  ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ].divide(SizedBox(width: 8.0)),
                      ),
                      Text(
                        widget!.subtitle!,
                        maxLines: 1,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.montserrat(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              color: Color(0xFF484848),
                              fontSize: 12.0,
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                              lineHeight: 1.5,
                            ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ].divide(SizedBox(height: 2.0)),
                  ),
                ),
                if (_sent || _received)
                  _TonePill(
                    text: widget!.amount!,
                    sent: _sent,
                  )
                else
                  Text(
                    widget!.amount!,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w500,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          fontSize: 12.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.w500,
                          fontStyle:
                              FlutterFlowTheme.of(context).bodyMedium.fontStyle,
                        ),
                  ),
              ].divide(SizedBox(width: 12.0)),
            ),
          ),
          if (widget!.showDivider ?? true)
            Divider(
              height: 1.0,
              thickness: 1.0,
              color: Color(0x14000000),
            ),
        ],
      ),
    );
  }
}

/// The amount on a line between merchants: solid yellow for sent, soft green for
/// received. Ink on the yellow, dark green on the green, so both read at a glance.
class _TonePill extends StatelessWidget {
  const _TonePill({required this.text, required this.sent});

  final String text;
  final bool sent;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.85, end: 1.0),
      duration: MediaQuery.disableAnimationsOf(context)
          ? Duration.zero
          : Duration(milliseconds: 520),
      curve: Curves.elasticOut,
      builder: (context, scale, child) =>
          Transform.scale(scale: scale, child: child),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 9.0, vertical: 4.0),
        decoration: BoxDecoration(
          color: sent ? Color(0xFFFFC21A) : Color(0x1F00DA76),
          borderRadius: BorderRadius.circular(100.0),
        ),
        child: Text(
          text,
          style: GoogleFonts.montserrat(
            fontSize: 12.0,
            fontWeight: FontWeight.w600,
            color: sent ? Color(0xFF111111) : Color(0xFF00794A),
          ),
        ),
      ),
    );
  }
}
