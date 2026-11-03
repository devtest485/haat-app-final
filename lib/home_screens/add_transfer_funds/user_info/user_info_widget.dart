import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'user_info_model.dart';
export 'user_info_model.dart';

/// "You're sending to": who the money goes to, and what is being sent.
///
/// Without arguments it is the bank-transfer sheet as designed. A transfer to another
/// merchant passes the person, the [amount] and [note], and an [onConfirm] that does the
/// sending; [busy] and [error] show how that went.
class UserInfoWidget extends StatefulWidget {
  const UserInfoWidget({
    super.key,
    this.name,
    this.subtitle,
    this.amount,
    this.note,
    this.error,
    this.busy = false,
    this.confirmLabel,
    this.disclaimer,
    this.onConfirm,
  });

  final String? name;
  final String? subtitle;
  final String? amount;
  final String? note;
  final String? error;
  final bool busy;
  final String? confirmLabel;
  final String? disclaimer;
  final Future<void> Function()? onConfirm;

  @override
  State<UserInfoWidget> createState() => _UserInfoWidgetState();
}

class _UserInfoWidgetState extends State<UserInfoWidget> {
  late UserInfoModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UserInfoModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  TextStyle _montserrat(
    double size, {
    FontWeight weight = FontWeight.w400,
    Color color = Colors.black,
  }) =>
      FlutterFlowTheme.of(context).bodyMedium.override(
            font: GoogleFonts.montserrat(
              fontWeight: weight,
              fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
            ),
            color: color,
            fontSize: size,
            letterSpacing: 0.0,
            fontWeight: weight,
            fontStyle: FlutterFlowTheme.of(context).bodyMedium.fontStyle,
          );

  Widget _line(String label, String value, {bool strong = false}) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: _montserrat(13, color: Color(0xFF6B6B72))),
          SizedBox(width: 16.0),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: _montserrat(
                strong ? 16 : 13,
                weight: strong ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    final details = widget.amount != null;
    final note = widget.note?.trim() ?? '';

    return Container(
      width: double.infinity,
      height: details ? null : 352.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
            bottom: details ? MediaQuery.paddingOf(context).bottom : 0.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 36.0,
                    height: 4.0,
                    decoration: BoxDecoration(
                      color: Color(0x47000000),
                      borderRadius: BorderRadius.circular(100.0),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 9.0, 0.0, 0.0),
              child: Text(
                'You’re sending to',
                textAlign: TextAlign.center,
                style: _montserrat(16, weight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 15.0, 0.0, 0.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/images/info.png',
                  width: details ? 120.0 : 154.6,
                  height: details ? 109.4 : 140.9,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20.0, 5.0, 20.0, 0.0),
              child: Text(
                widget.name ?? 'Mohammed Khalid Alfadil Hammad',
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: _montserrat(18, weight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20.0, 8.0, 20.0, 0.0),
              child: Text(
                widget.subtitle ?? 'Saving account',
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: _montserrat(14),
              ),
            ),
            if (details)
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20.0, 20.0, 20.0, 0.0),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  child: Column(
                    children: [
                      _line('Amount', widget.amount!, strong: true),
                      if (note.isNotEmpty) ...[
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 12.0),
                          child: Divider(
                              height: 1.0, thickness: 1.0, color: Color(0xFFEDEDF0)),
                        ),
                        _line('Note', note),
                      ],
                    ],
                  ),
                ),
              ),
            AnimatedSize(
              duration: Duration(milliseconds: 200),
              child: widget.error == null
                  ? SizedBox(width: double.infinity)
                  : Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(20.0, 14.0, 20.0, 0.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.error_outline_rounded,
                              size: 18.0, color: Color(0xFFD93025)),
                          SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              widget.error!,
                              style: _montserrat(13, color: Color(0xFFD93025)),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(
                  20.0, 22.0, 20.0, widget.disclaimer == null ? 15.0 : 10.0),
              child: Semantics(
                button: true,
                enabled: !widget.busy,
                label: widget.confirmLabel ?? 'Yes Confirm',
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: widget.busy
                      ? null
                      : () async {
                          if (widget.onConfirm != null) {
                            await widget.onConfirm!();
                            return;
                          }
                          context.pushNamed(PaymentReviewWidget.routeName);
                        },
                  child: Container(
                    width: double.infinity,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      borderRadius: BorderRadius.circular(106.67),
                    ),
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: widget.busy
                        ? SizedBox(
                            width: 22.0,
                            height: 22.0,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                          )
                        : Text(
                            widget.confirmLabel ?? 'Yes Confirm',
                            textAlign: TextAlign.center,
                            style: _montserrat(
                              18,
                              weight: FontWeight.w600,
                              color: FlutterFlowTheme.of(context).primaryText,
                            ),
                          ),
                  ),
                ),
              ),
            ),
            if (widget.disclaimer != null)
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(20.0, 0.0, 20.0, 16.0),
                child: Text(
                  widget.disclaimer!,
                  textAlign: TextAlign.center,
                  style: _montserrat(11.5, color: Color(0xFF6B6B72)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
