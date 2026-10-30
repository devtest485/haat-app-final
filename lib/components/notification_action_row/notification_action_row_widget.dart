import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'notification_action_row_model.dart';
export 'notification_action_row_model.dart';

class NotificationActionRowWidget extends StatefulWidget {
  const NotificationActionRowWidget({
    super.key,
    String? title,
    String? body,
    String? actionKey,
    bool? showDot,
    bool? showDivider,
    required this.onTap,
  })  : this.title = title ?? '',
        this.body = body ?? '',
        this.actionKey = actionKey ?? '',
        this.showDot = showDot ?? true,
        this.showDivider = showDivider ?? false;

  final String title;
  final String body;
  final String actionKey;
  final bool showDot;
  final bool showDivider;
  final Future Function()? onTap;

  @override
  State<NotificationActionRowWidget> createState() =>
      _NotificationActionRowWidgetState();
}

class _NotificationActionRowWidgetState
    extends State<NotificationActionRowWidget> {
  late NotificationActionRowModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => NotificationActionRowModel());
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
                          if ((widget!.actionKey == 'verify_identity') ||
                              (widget!.actionKey == 'update_identity'))
                            Icon(
                              Icons.person_outline_sharp,
                              color: Colors.black,
                              size: 16.0,
                            ),
                          if (widget!.actionKey == 'trade_licence')
                            Icon(
                              Icons.business_center_outlined,
                              color: Colors.black,
                              size: 16.0,
                            ),
                          if (widget!.actionKey == 'add_team')
                            Icon(
                              Icons.add_rounded,
                              color: Colors.black,
                              size: 16.0,
                            ),
                        ],
                      ),
                    ),
                    if (widget!.showDot)
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
                      Text(
                        widget!.title,
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
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
                Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0x73000000),
                  size: 20.0,
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
