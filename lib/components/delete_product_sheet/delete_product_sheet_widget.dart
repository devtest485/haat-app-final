import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

import 'dart:ui';

import '/custom_code/actions/index.dart' as actions;
import '/index.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'delete_product_sheet_model.dart';
export 'delete_product_sheet_model.dart';

class DeleteProductSheetWidget extends StatefulWidget {
  const DeleteProductSheetWidget({
    super.key,
    required this.productId,
    required this.name,
  });

  final String? productId;
  final String? name;

  @override
  State<DeleteProductSheetWidget> createState() =>
      _DeleteProductSheetWidgetState();
}

class _DeleteProductSheetWidgetState extends State<DeleteProductSheetWidget> {
  late DeleteProductSheetModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => DeleteProductSheetModel());
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
      height: 270.0,
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).secondaryBackground,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            FlutterFlowTheme.of(context).designToken.radius.sm,
          ),
          topRight: Radius.circular(
            FlutterFlowTheme.of(context).designToken.radius.sm,
          ),
        ),
      ),
      alignment: AlignmentDirectional(0.0, 0.0),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 10.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: (FFCrossAxisAlignment.start).flutterValue,
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
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 25.0, 0.0, 0.0),
                  child: Text(
                    'Delete ${valueOrDefault<String>(widget!.name, 'this product')}?',
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontStyle: FlutterFlowTheme.of(context)
                            .bodyMedium
                            .fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).primaryBackground,
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
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 0.0),
                  child: Text(
                    'It leaves your Cashier. Past sales stay in your records.',
                    textAlign: TextAlign.start,
                    style: FlutterFlowTheme.of(context).bodyMedium.override(
                      font: GoogleFonts.montserrat(
                        fontWeight: FontWeight.normal,
                        fontStyle: FlutterFlowTheme.of(context)
                            .bodyMedium
                            .fontStyle,
                      ),
                      color: FlutterFlowTheme.of(context).primaryBackground,
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
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 10.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      if (_model.deleting) {
                        return;
                      }
                      _model.deleting = true;
                      safeSetState(() {});
                      _model.token = await actions.haatAccessToken();
                      _model.deleteResult = await HaatAuthGroup
                          .deleteProductCall
                          .call(
                            productId: widget!.productId,
                            accessToken: _model.token,
                          );

                      if ((_model.deleteResult?.succeeded ?? true)) {
                        Navigator.pop(context, true);
                      } else {
                        _model.deleting = false;
                        safeSetState(() {});
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              valueOrDefault<String>(
                                HaatAuthGroup.deleteProductCall.message(
                                  (_model.deleteResult?.jsonBody ?? ''),
                                ),
                                'The product could not be deleted. Try again.',
                              ),
                              style: TextStyle(),
                            ),
                            duration: Duration(milliseconds: 4000),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      height: 52.3,
                      decoration: BoxDecoration(
                        color: Color(0xFFFF3128),
                        borderRadius: BorderRadius.circular(24.0),
                      ),
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Text(
                        _model.deleting ? 'Deleting…' : 'Delete',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
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
                  InkWell(
                    splashColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      Navigator.pop(context, false);
                    },
                    child: Container(
                      width: double.infinity,
                      height: 44.0,
                      alignment: AlignmentDirectional(0.0, 0.0),
                      child: Text(
                        'Cancel',
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                          font: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                          ),
                          color: FlutterFlowTheme.of(context).primaryBackground,
                          fontSize: 15.0,
                          letterSpacing: 0.0,
                          fontWeight: FontWeight.bold,
                          fontStyle: FlutterFlowTheme.of(context)
                              .bodyMedium
                              .fontStyle,
                        ),
                      ),
                    ),
                  ),
                ].divide(SizedBox(height: 6.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
