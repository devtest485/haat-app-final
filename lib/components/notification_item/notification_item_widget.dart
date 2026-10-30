import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'notification_item_model.dart';
export 'notification_item_model.dart';

class NotificationItemWidget extends StatefulWidget {
  const NotificationItemWidget({
    super.key,
    String? title,
    String? body,
    String? time,
    String? imageUrl,
    String? category,
    bool? unread,
    bool? showDivider,
    required this.onTap,
  })  : this.title = title ?? '',
        this.body = body ?? '',
        this.time = time ?? '',
        this.imageUrl = imageUrl ?? '',
        this.category = category ?? 'update',
        this.unread = unread ?? false,
        this.showDivider = showDivider ?? false;

  final String title;
  final String body;
  final String time;
  final String imageUrl;
  final String category;
  final bool unread;
  final bool showDivider;
  final Future Function()? onTap;

  @override
  State<NotificationItemWidget> createState() => _NotificationItemWidgetState();
}

class _NotificationItemWidgetState extends State<NotificationItemWidget> {
  late NotificationItemModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificationItemModel());
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
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(5.0, 8.0, 5.0, 8.0),
          child: InkWell(
            splashColor: Colors.transparent,
            focusColor: Colors.transparent,
            hoverColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: () async {
              await widget.onTap?.call();
            },
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: (FFCrossAxisAlignment.start).flutterValue,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Stack(
                  alignment: AlignmentDirectional(1.0, -1.0),
                  children: [
                    Container(
                      width: 32.0,
                      height: 32.0,
                      decoration: BoxDecoration(
                        color: Color(0xFFF1F1F1),
                        shape: BoxShape.circle,
                      ),
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Stack(
                        alignment: AlignmentDirectional(0.0, 0.0),
                        children: [
                          if ((widget!.imageUrl == null ||
                                  widget!.imageUrl == '') &&
                              (widget!.category == 'offer'))
                            Icon(
                              Icons.local_offer_outlined,
                              color: Colors.black,
                              size: 16.0,
                            ),
                          if ((widget!.imageUrl == null ||
                                  widget!.imageUrl == '') &&
                              (widget!.category != 'offer'))
                            Icon(
                              Icons.lightbulb_outline_rounded,
                              color: Colors.black,
                              size: 16.0,
                            ),
                          if (widget!.imageUrl != null &&
                              widget!.imageUrl != '')
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16.0),
                              child: Image.network(
                                widget!.imageUrl,
                                width: 32.0,
                                height: 32.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (widget!.unread)
                      Align(
                        alignment: AlignmentDirectional(1.0, -1.0),
                        child: Container(
                          width: 8.0,
                          height: 8.0,
                          decoration: BoxDecoration(
                            color: Color(0xFFFF3128),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                  ],
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
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.inter(
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
                            ),
                          ),
                          Text(
                            widget!.time,
                            style: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.inter(
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color: Color(0x73000000),
                                  fontSize: 10.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.bold,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                  lineHeight: 1.5,
                                ),
                          ),
                        ].divide(SizedBox(width: 8.0)),
                      ),
                      if (widget!.body != '')
                        Text(
                          widget!.body,
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.inter(
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
                        ),
                    ].divide(SizedBox(height: 2.0)),
                  ),
                ),
              ].divide(SizedBox(width: 12.0)),
            ),
          ),
        ),
        if (widget!.showDivider)
          Divider(
            height: 1.0,
            thickness: 1.0,
            color: Color(0x14000000),
          ),
      ],
    );
  }
}
