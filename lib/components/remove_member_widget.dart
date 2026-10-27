import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'remove_member_model.dart';
export 'remove_member_model.dart';

class RemoveMemberWidget extends StatefulWidget {
  const RemoveMemberWidget({
    super.key,
    this.member,
  });

  final dynamic member;

  @override
  State<RemoveMemberWidget> createState() => _RemoveMemberWidgetState();
}

class _RemoveMemberWidgetState extends State<RemoveMemberWidget> {
  late RemoveMemberModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => RemoveMemberModel());
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
      height: 210.59,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
              FlutterFlowTheme.of(context).designToken.radius.sm),
          topRight: Radius.circular(
              FlutterFlowTheme.of(context).designToken.radius.sm),
        ),
      ),
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              decoration: BoxDecoration(),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: (FFCrossAxisAlignment.start).flutterValue,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 10.0, 0.0, 0.0),
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
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 25.0, 0.0, 0.0),
                    child: Text(
                      'Remove ${functions.staffDisplayName(widget!.member)}?',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color:
                                FlutterFlowTheme.of(context).primaryBackground,
                            fontSize: 17.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.bold,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                    child: Text(
                      valueOrDefault<String>(
                        _model.error,
                        '${valueOrDefault<String>(
                          functions.staffFirstName(getJsonField(
                            widget!.member,
                            r'''$.fullName''',
                          ).toString()),
                          'They',
                        )} will lose access to your store. Past sales stay in your records.',
                      ),
                      textAlign: TextAlign.start,
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.montserrat(
                              fontWeight: FontWeight.normal,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: _model.error != null
                                ? FlutterFlowTheme.of(context).error
                                : FlutterFlowTheme.of(context)
                                    .primaryBackground,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.normal,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                            lineHeight: 1.2,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
              child: Container(
                width: double.infinity,
                height: 52.76,
                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      focusColor: Colors.transparent,
                      hoverColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                      onTap: () async {
                        if (_model.removing) {
                          return;
                        }
                        _model.removing = true;
                        _model.error = null;
                        safeSetState(() {});
                        _model.token = await actions.haatAccessToken();
                        _model.revokeIds = functions
                            .staffRevokeIds(widget!.member, null)
                            .toList()
                            .cast<String>();
                        _model.loopIndex = 0;
                        while (_model.loopIndex < _model.revokeIds.length) {
                          _model.revokeResult =
                              await HaatAuthGroup.revokeRoleCall.call(
                            assignmentId: _model.revokeIds
                                .elementAtOrNull(_model.loopIndex),
                            userId: getJsonField(
                              widget!.member,
                              r'''$.userId''',
                            ).toString(),
                            accessToken: _model.token,
                          );

                          if (!(_model.revokeResult?.succeeded ?? true)) {
                            _model.error = valueOrDefault<String>(
                              HaatAuthGroup.revokeRoleCall.message(
                                (_model.revokeResult?.jsonBody ?? ''),
                              ),
                              'This person could not be removed. Check your connection and try again.',
                            );
                            _model.removing = false;
                            safeSetState(() {});
                            return;
                          }
                          _model.loopIndex = _model.loopIndex + 1;
                        }
                        Navigator.pop(context, true);
                      },
                      child: Container(
                        width: double.infinity,
                        height: 52.3,
                        decoration: BoxDecoration(
                          color: Color(0xFFFF3128),
                          borderRadius: BorderRadius.circular(24.0),
                        ),
                        alignment: AlignmentDirectional(0.0, 0.0),
                        child: _model.removing
                            ? SizedBox(
                                width: 22.0,
                                height: 22.0,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              )
                            : Text(
                                'Remove',
                                style: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .override(
                                      font: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .fontStyle,
                                      ),
                                      fontSize: 18.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
