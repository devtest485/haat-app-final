import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_choice_chips.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/form_field_controller.dart';
import 'dart:ui';
import '/flutter_flow/custom_functions.dart' as functions;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'transaction_filter_sheet_model.dart';
export 'transaction_filter_sheet_model.dart';

/// All Transactions filter sheet (Figma Bottom Sheet - Filters): direction,
/// status and method, with a live count on the button.
///
/// onApply hands the choices back.
class TransactionFilterSheetWidget extends StatefulWidget {
  const TransactionFilterSheetWidget({
    super.key,
    required this.transactions,
    int? filterIndex,
    String? direction,
    String? status,
    String? method,
    required this.onApply,
  })  : this.filterIndex = filterIndex ?? 0,
        this.direction = direction ?? 'All',
        this.status = status ?? 'All',
        this.method = method ?? 'All types';

  final List<dynamic>? transactions;
  final int filterIndex;
  final String direction;
  final String status;
  final String method;
  final Future Function(String direction, String status, String method)?
      onApply;

  @override
  State<TransactionFilterSheetWidget> createState() =>
      _TransactionFilterSheetWidgetState();
}

class _TransactionFilterSheetWidgetState
    extends State<TransactionFilterSheetWidget> {
  late TransactionFilterSheetModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TransactionFilterSheetModel());
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
      decoration: BoxDecoration(
        color: FlutterFlowTheme.of(context).primaryText,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Padding(
        padding: EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 44.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: (FFCrossAxisAlignment.start).flutterValue,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: (FFMainAxisAlignment.center).flutterValue,
                children: [
                  Container(
                    width: 36.0,
                    height: 4.0,
                    decoration: BoxDecoration(
                      color: Color(0x40000000),
                      borderRadius: BorderRadius.circular(2.0),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 16.0, 24.0, 32.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: (FFCrossAxisAlignment.start).flutterValue,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment:
                          (FFMainAxisAlignment.spaceBetween).flutterValue,
                      children: [
                        Text(
                          'Filters',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: Color(0xFF111111),
                                    fontSize: 18.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                    lineHeight: 1.44,
                                  ),
                        ),
                        if (functions.activeTransactionFilters(
                                _model.directionChipsValue,
                                _model.statusChipsValue,
                                _model.methodChipsValue) >
                            0)
                          InkWell(
                            splashColor: Colors.transparent,
                            focusColor: Colors.transparent,
                            hoverColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                            onTap: () async {
                              safeSetState(() {
                                _model.directionChipsValueController?.value = [
                                  'All'
                                ];
                              });
                              safeSetState(() {
                                _model.statusChipsValueController?.value = [
                                  'All'
                                ];
                              });
                              safeSetState(() {
                                _model.methodChipsValueController?.value = [
                                  'All types'
                                ];
                              });
                            },
                            child: Text(
                              'Clear',
                              style: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .override(
                                    font: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: Color(0xFF484848),
                                    fontSize: 13.0,
                                    letterSpacing: 0.0,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                    decoration: TextDecoration.underline,
                                  ),
                            ),
                          ),
                      ],
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment:
                          (FFCrossAxisAlignment.start).flutterValue,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          'Direction',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: Color(0xFF111111),
                                    fontSize: 13.0,
                                    letterSpacing: -0.33,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                    lineHeight: 1.54,
                                  ),
                        ),
                        FlutterFlowChoiceChips(
                          options: [
                            ChipData('All'),
                            ChipData('Incoming'),
                            ChipData('Outgoing')
                          ],
                          onChanged: (val) => safeSetState(() =>
                              _model.directionChipsValue = val?.firstOrNull),
                          selectedChipStyle: ChipStyle(
                            backgroundColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            textStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 12.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                  lineHeight: 1.33,
                                ),
                            iconColor: FlutterFlowTheme.of(context).primaryText,
                            iconSize: 16.0,
                            labelPadding: EdgeInsetsDirectional.fromSTEB(
                                9.0, 5.5, 9.0, 5.5),
                            elevation: 0.0,
                            borderRadius: BorderRadius.circular(999.0),
                          ),
                          unselectedChipStyle: ChipStyle(
                            backgroundColor: Color(0x7CEBEBEB),
                            textStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  fontSize: 12.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                  lineHeight: 1.33,
                                ),
                            iconColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            iconSize: 16.0,
                            labelPadding: EdgeInsetsDirectional.fromSTEB(
                                9.0, 5.5, 9.0, 5.5),
                            elevation: 0.0,
                            borderRadius: BorderRadius.circular(999.0),
                          ),
                          chipSpacing: 8.0,
                          rowSpacing: 8.0,
                          multiselect: false,
                          initialized: _model.directionChipsValue != null,
                          alignment: WrapAlignment.start,
                          controller: _model.directionChipsValueController ??=
                              FormFieldController<List<String>>(
                            [widget!.direction],
                          ),
                          wrapped: true,
                        ),
                      ].divide(SizedBox(height: 8.0)),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment:
                          (FFCrossAxisAlignment.start).flutterValue,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          'Status',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: Color(0xFF111111),
                                    fontSize: 13.0,
                                    letterSpacing: -0.33,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                    lineHeight: 1.54,
                                  ),
                        ),
                        FlutterFlowChoiceChips(
                          options: [
                            ChipData('All'),
                            ChipData('Successful'),
                            ChipData('Pending'),
                            ChipData('Failed')
                          ],
                          onChanged: (val) => safeSetState(
                              () => _model.statusChipsValue = val?.firstOrNull),
                          selectedChipStyle: ChipStyle(
                            backgroundColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            textStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 12.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                  lineHeight: 1.33,
                                ),
                            iconColor: FlutterFlowTheme.of(context).primaryText,
                            iconSize: 16.0,
                            labelPadding: EdgeInsetsDirectional.fromSTEB(
                                9.0, 5.5, 9.0, 5.5),
                            elevation: 0.0,
                            borderRadius: BorderRadius.circular(999.0),
                          ),
                          unselectedChipStyle: ChipStyle(
                            backgroundColor: Color(0x7CEBEBEB),
                            textStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  fontSize: 12.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                  lineHeight: 1.33,
                                ),
                            iconColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            iconSize: 16.0,
                            labelPadding: EdgeInsetsDirectional.fromSTEB(
                                9.0, 5.5, 9.0, 5.5),
                            elevation: 0.0,
                            borderRadius: BorderRadius.circular(999.0),
                          ),
                          chipSpacing: 8.0,
                          rowSpacing: 8.0,
                          multiselect: false,
                          initialized: _model.statusChipsValue != null,
                          alignment: WrapAlignment.start,
                          controller: _model.statusChipsValueController ??=
                              FormFieldController<List<String>>(
                            [widget!.status],
                          ),
                          wrapped: true,
                        ),
                      ].divide(SizedBox(height: 8.0)),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment:
                          (FFCrossAxisAlignment.start).flutterValue,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          'Method',
                          style:
                              FlutterFlowTheme.of(context).bodyMedium.override(
                                    font: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: Color(0xFF111111),
                                    fontSize: 13.0,
                                    letterSpacing: -0.33,
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                    lineHeight: 1.54,
                                  ),
                        ),
                        FlutterFlowChoiceChips(
                          options: [
                            ChipData('All types'),
                            ChipData('Tap to Pay'),
                            ChipData('QR Code'),
                            ChipData('Payment link'),
                            ChipData('Transfer'),
                            ChipData('Add funds')
                          ],
                          onChanged: (val) => safeSetState(
                              () => _model.methodChipsValue = val?.firstOrNull),
                          selectedChipStyle: ChipStyle(
                            backgroundColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            textStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.w500,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color:
                                      FlutterFlowTheme.of(context).primaryText,
                                  fontSize: 12.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.w500,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                  lineHeight: 1.33,
                                ),
                            iconColor: FlutterFlowTheme.of(context).primaryText,
                            iconSize: 16.0,
                            labelPadding: EdgeInsetsDirectional.fromSTEB(
                                9.0, 5.5, 9.0, 5.5),
                            elevation: 0.0,
                            borderRadius: BorderRadius.circular(999.0),
                          ),
                          unselectedChipStyle: ChipStyle(
                            backgroundColor: Color(0x7CEBEBEB),
                            textStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .override(
                                  font: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.normal,
                                    fontStyle: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .fontStyle,
                                  ),
                                  color: FlutterFlowTheme.of(context)
                                      .primaryBackground,
                                  fontSize: 12.0,
                                  letterSpacing: 0.0,
                                  fontWeight: FontWeight.normal,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .bodyMedium
                                      .fontStyle,
                                  lineHeight: 1.33,
                                ),
                            iconColor:
                                FlutterFlowTheme.of(context).primaryBackground,
                            iconSize: 16.0,
                            labelPadding: EdgeInsetsDirectional.fromSTEB(
                                9.0, 5.5, 9.0, 5.5),
                            elevation: 0.0,
                            borderRadius: BorderRadius.circular(999.0),
                          ),
                          chipSpacing: 8.0,
                          rowSpacing: 8.0,
                          multiselect: false,
                          initialized: _model.methodChipsValue != null,
                          alignment: WrapAlignment.start,
                          controller: _model.methodChipsValueController ??=
                              FormFieldController<List<String>>(
                            [widget!.method],
                          ),
                          wrapped: true,
                        ),
                      ].divide(SizedBox(height: 8.0)),
                    ),
                  ].divide(SizedBox(height: 24.0)),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(24.0, 0.0, 24.0, 0.0),
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    await widget.onApply?.call(
                      valueOrDefault<String>(
                        _model.directionChipsValue,
                        'All',
                      ),
                      valueOrDefault<String>(
                        _model.statusChipsValue,
                        'All',
                      ),
                      valueOrDefault<String>(
                        _model.methodChipsValue,
                        'All types',
                      ),
                    );
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: double.infinity,
                    height: 50.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      borderRadius: BorderRadius.circular(999.0),
                    ),
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Text(
                      functions.transactionFilterLabel(
                          widget!.transactions?.toList(),
                          widget!.filterIndex,
                          _model.directionChipsValue,
                          _model.statusChipsValue,
                          _model.methodChipsValue),
                      style: FlutterFlowTheme.of(context).bodyMedium.override(
                            font: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                            color: FlutterFlowTheme.of(context).primaryText,
                            fontSize: 18.0,
                            letterSpacing: 0.0,
                            fontWeight: FontWeight.w500,
                            fontStyle: FlutterFlowTheme.of(context)
                                .bodyMedium
                                .fontStyle,
                            lineHeight: 1.44,
                          ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
