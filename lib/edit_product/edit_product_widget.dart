import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/ff_builtin_enums.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

import 'dart:ui';

import '/custom_code/actions/index.dart' as actions;
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import '/components/delete_product_sheet/delete_product_sheet_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'edit_product_model.dart';
export 'edit_product_model.dart';

class EditProductWidget extends StatefulWidget {
  const EditProductWidget({super.key, required this.product});

  final dynamic product;

  static String routeName = 'EditProduct';
  static String routePath = '/editProduct';

  @override
  State<EditProductWidget> createState() => _EditProductWidgetState();
}

class _EditProductWidgetState extends State<EditProductWidget> {
  late EditProductModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => EditProductModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.outOfStock =
          getJsonField(widget!.product, r'''$.outOfStock''') == true;
      safeSetState(() {});
    });

    _model.textController1 ??= TextEditingController(
      text: getJsonField(widget!.product, r'''$.name''').toString(),
    );
    _model.textFieldFocusNode1 ??= FocusNode();

    _model.textController2 ??= TextEditingController(
      text: functions.minorToPriceText(
        getJsonField(widget!.product, r'''$.priceMinor''').toString(),
      ),
    );
    _model.textFieldFocusNode2 ??= FocusNode();

    _model.textController3 ??= TextEditingController(
      text: getJsonField(widget!.product, r'''$.unit''').toString(),
    );
    _model.textFieldFocusNode3 ??= FocusNode();

    _model.textController4 ??= TextEditingController(
      text: functions.quantityText(
        getJsonField(widget!.product, r'''$.quantity'''),
      ),
    );
    _model.textFieldFocusNode4 ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    width: double.infinity,
                    height: 162.0,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: Image.asset('assets/images/GrayPageBg.png')
                            .image,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(),
                child: Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15.0, 0.0, 15.0, 0.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                              0.0,
                              67.0,
                              0.0,
                              20.0,
                            ),
                            child: Container(
                              decoration: BoxDecoration(),
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0,
                                      19.0,
                                      0.0,
                                      0.0,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          (FFMainAxisAlignment.spaceBetween)
                                              .flutterValue,
                                      children: [
                                        InkWell(
                                          splashColor: Colors.transparent,
                                          focusColor: Colors.transparent,
                                          hoverColor: Colors.transparent,
                                          highlightColor: Colors.transparent,
                                          onTap: () async {
                                            context.safePop();
                                          },
                                          child: Icon(
                                            Icons.arrow_back,
                                            color: FlutterFlowTheme.of(context)
                                                .primaryBackground,
                                            size: 24.0,
                                          ),
                                        ),
                                        Text(
                                          'Edit product',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.montserrat(
                                                  fontWeight: FontWeight.bold,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                        context,
                                                      ).bodyMedium.fontStyle,
                                                ),
                                                color: FlutterFlowTheme.of(
                                                  context,
                                                ).primaryBackground,
                                                fontSize: 15.0,
                                                letterSpacing: 0.0,
                                                fontWeight: FontWeight.bold,
                                                fontStyle: FlutterFlowTheme.of(
                                                  context,
                                                ).bodyMedium.fontStyle,
                                              ),
                                        ),
                                        Text(
                                          '.',
                                          style: FlutterFlowTheme.of(context)
                                              .bodyMedium
                                              .override(
                                                font: GoogleFonts.inter(
                                                  fontWeight:
                                                      FlutterFlowTheme.of(
                                                        context,
                                                      ).bodyMedium.fontWeight,
                                                  fontStyle:
                                                      FlutterFlowTheme.of(
                                                        context,
                                                      ).bodyMedium.fontStyle,
                                                ),
                                                letterSpacing: 0.0,
                                                fontWeight: FlutterFlowTheme.of(
                                                  context,
                                                ).bodyMedium.fontWeight,
                                                fontStyle: FlutterFlowTheme.of(
                                                  context,
                                                ).bodyMedium.fontStyle,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0,
                                      20.0,
                                      0.0,
                                      0.0,
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          InkWell(
                                            splashColor: Colors.transparent,
                                            focusColor: Colors.transparent,
                                            hoverColor: Colors.transparent,
                                            highlightColor: Colors.transparent,
                                            onTap: () async {
                                              _model.pickedPhoto = await actions
                                                  .haatPickProductPhoto(
                                                    context,
                                                  );
                                              if (_model.pickedPhoto != null) {
                                                _model.photo =
                                                    _model.pickedPhoto;
                                                safeSetState(() {});
                                              }
                                            },
                                            child: Container(
                                              width: double.infinity,
                                              height: 153.0,
                                              decoration: BoxDecoration(
                                                color: FlutterFlowTheme.of(
                                                  context,
                                                ).primaryText,
                                                borderRadius:
                                                    BorderRadius.circular(12.0),
                                              ),
                                              child: Builder(
                                                builder: (context) {
                                                  if (_model.photo != null &&
                                                      (_model
                                                              .photo
                                                              ?.bytes
                                                              ?.isNotEmpty ??
                                                          false)) {
                                                    return ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12.0,
                                                          ),
                                                      child: Image.memory(
                                                        _model.photo?.bytes ??
                                                            Uint8List.fromList(
                                                              [],
                                                            ),
                                                        width: double.infinity,
                                                        height: 153.0,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    );
                                                  } else if (functions
                                                      .productHasPhoto(
                                                        getJsonField(
                                                          widget!.product,
                                                          r'''$.imagePath''',
                                                        ).toString(),
                                                      )) {
                                                    return ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12.0,
                                                          ),
                                                      child: Image.network(
                                                        functions.bannerImageUrl(
                                                          getJsonField(
                                                            widget!.product,
                                                            r'''$.imagePath''',
                                                          ).toString(),
                                                          FFDevEnvironmentValues()
                                                              .baseURL,
                                                        ),
                                                        width: double.infinity,
                                                        height: 153.0,
                                                        fit: BoxFit.contain,
                                                      ),
                                                    );
                                                  } else {
                                                    return Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          (FFMainAxisAlignment
                                                                  .center)
                                                              .flutterValue,
                                                      children: [
                                                        Container(
                                                          width: 40.0,
                                                          height: 40.0,
                                                          decoration: BoxDecoration(
                                                            color: FlutterFlowTheme.of(
                                                              context,
                                                            ).secondaryBackground,
                                                            shape:
                                                                BoxShape.circle,
                                                          ),
                                                          child: Icon(
                                                            Icons.add,
                                                            color: FlutterFlowTheme.of(
                                                              context,
                                                            ).primaryBackground,
                                                            size: 20.0,
                                                          ),
                                                        ),
                                                        Text(
                                                          'Add photo',
                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                            font: GoogleFonts.montserrat(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                            ),
                                                            color: FlutterFlowTheme.of(
                                                              context,
                                                            ).primaryBackground,
                                                            fontSize: 13.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                        ),
                                                        Text(
                                                          'PNG only, at least 300 × 300 px',
                                                          style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                            font: GoogleFonts.montserrat(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .bodyMedium
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                            ),
                                                            color: Color(
                                                              0x74000000,
                                                            ),
                                                            fontSize: 12.0,
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                        ),
                                                      ].divide(SizedBox(height: 8.0)),
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0,
                                      20.0,
                                      0.0,
                                      0.0,
                                    ),
                                    child: Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryBackground,
                                      ),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  (FFCrossAxisAlignment.start)
                                                      .flutterValue,
                                              textBaseline:
                                                  TextBaseline.alphabetic,
                                              children: [
                                                Text(
                                                  'Name',
                                                  style:
                                                      FlutterFlowTheme.of(
                                                        context,
                                                      ).bodyMedium.override(
                                                        font: GoogleFonts.montserrat(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                    context,
                                                                  )
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                              context,
                                                            ).primaryBackground,
                                                        fontSize: 13.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsetsDirectional.fromSTEB(
                                                        3.0,
                                                        0.0,
                                                        0.0,
                                                        0.0,
                                                      ),
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 56.0,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                            context,
                                                          ).primaryText,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12.0,
                                                          ),
                                                      border: Border.all(
                                                        color: Color(
                                                          0xFFD9D9D9,
                                                        ),
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                    alignment:
                                                        AlignmentDirectional(
                                                          0.0,
                                                          0.0,
                                                        ),
                                                    child: Container(
                                                      width: double.infinity,
                                                      child: TextFormField(
                                                        controller: _model
                                                            .textController1,
                                                        focusNode: _model
                                                            .textFieldFocusNode1,
                                                        autofocus: false,
                                                        enabled: true,
                                                        obscureText: false,
                                                        decoration: InputDecoration(
                                                          isDense: true,
                                                          labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                            font: GoogleFonts.inter(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .labelMedium
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .labelMedium
                                                                      .fontStyle,
                                                            ),
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .labelMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .labelMedium
                                                                    .fontStyle,
                                                          ),
                                                          hintText: 'Enter product name',
                                                          hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                            font: GoogleFonts.inter(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .labelMedium
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .labelMedium
                                                                      .fontStyle,
                                                            ),
                                                            color: Color(
                                                              0xFFBABABA,
                                                            ),
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .labelMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .labelMedium
                                                                    .fontStyle,
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                      color: Color(
                                                                        0x00000000,
                                                                      ),
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8.0,
                                                                    ),
                                                              ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                      color: Color(
                                                                        0x00000000,
                                                                      ),
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8.0,
                                                                    ),
                                                              ),
                                                          errorBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                              color:
                                                                  FlutterFlowTheme.of(
                                                                    context,
                                                                  ).error,
                                                              width: 1.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8.0,
                                                                ),
                                                          ),
                                                          focusedErrorBorder:
                                                              OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color:
                                                                      FlutterFlowTheme.of(
                                                                        context,
                                                                      ).error,
                                                                  width: 1.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8.0,
                                                                    ),
                                                              ),
                                                          filled: true,
                                                          fillColor:
                                                              FlutterFlowTheme.of(
                                                                context,
                                                              ).primaryText,
                                                        ),
                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          font: GoogleFonts.inter(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color:
                                                              FlutterFlowTheme.of(
                                                                context,
                                                              ).primaryBackground,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                    context,
                                                                  )
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                    context,
                                                                  )
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        maxLines: null,
                                                        cursorColor:
                                                            FlutterFlowTheme.of(
                                                              context,
                                                            ).primaryText,
                                                        enableInteractiveSelection:
                                                            true,
                                                        validator: _model
                                                            .textController1Validator
                                                            .asValidator(
                                                              context,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ].divide(SizedBox(height: 10.0)),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  (FFCrossAxisAlignment.start)
                                                      .flutterValue,
                                              textBaseline:
                                                  TextBaseline.alphabetic,
                                              children: [
                                                Text(
                                                  'Price (SDG)',
                                                  style:
                                                      FlutterFlowTheme.of(
                                                        context,
                                                      ).bodyMedium.override(
                                                        font: GoogleFonts.montserrat(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                    context,
                                                                  )
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                              context,
                                                            ).primaryBackground,
                                                        fontSize: 13.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsetsDirectional.fromSTEB(
                                                        3.0,
                                                        0.0,
                                                        0.0,
                                                        0.0,
                                                      ),
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 56.0,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                            context,
                                                          ).primaryText,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12.0,
                                                          ),
                                                      border: Border.all(
                                                        color: Color(
                                                          0xFFD9D9D9,
                                                        ),
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                    alignment:
                                                        AlignmentDirectional(
                                                          0.0,
                                                          0.0,
                                                        ),
                                                    child: Container(
                                                      width: double.infinity,
                                                      child: TextFormField(
                                                        controller: _model
                                                            .textController2,
                                                        focusNode: _model
                                                            .textFieldFocusNode2,
                                                        autofocus: false,
                                                        enabled: true,
                                                        obscureText: false,
                                                        decoration: InputDecoration(
                                                          isDense: true,
                                                          labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                            font: GoogleFonts.inter(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .labelMedium
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .labelMedium
                                                                      .fontStyle,
                                                            ),
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .labelMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .labelMedium
                                                                    .fontStyle,
                                                          ),
                                                          hintText:
                                                              'Enter price',
                                                          hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                            font: GoogleFonts.inter(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .labelMedium
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .labelMedium
                                                                      .fontStyle,
                                                            ),
                                                            color: Color(
                                                              0xFFBABABA,
                                                            ),
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .labelMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .labelMedium
                                                                    .fontStyle,
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                      color: Color(
                                                                        0x00000000,
                                                                      ),
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8.0,
                                                                    ),
                                                              ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                      color: Color(
                                                                        0x00000000,
                                                                      ),
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8.0,
                                                                    ),
                                                              ),
                                                          errorBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                              color:
                                                                  FlutterFlowTheme.of(
                                                                    context,
                                                                  ).error,
                                                              width: 1.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8.0,
                                                                ),
                                                          ),
                                                          focusedErrorBorder:
                                                              OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color:
                                                                      FlutterFlowTheme.of(
                                                                        context,
                                                                      ).error,
                                                                  width: 1.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8.0,
                                                                    ),
                                                              ),
                                                          filled: true,
                                                          fillColor:
                                                              FlutterFlowTheme.of(
                                                                context,
                                                              ).primaryText,
                                                        ),
                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          font: GoogleFonts.inter(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color:
                                                              FlutterFlowTheme.of(
                                                                context,
                                                              ).primaryBackground,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                    context,
                                                                  )
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                    context,
                                                                  )
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        maxLines: null,
                                                        keyboardType:
                                                            const TextInputType.numberWithOptions(
                                                              decimal: true,
                                                            ),
                                                        cursorColor:
                                                            FlutterFlowTheme.of(
                                                              context,
                                                            ).primaryText,
                                                        enableInteractiveSelection:
                                                            true,
                                                        validator: _model
                                                            .textController2Validator
                                                            .asValidator(
                                                              context,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ].divide(SizedBox(height: 10.0)),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  (FFCrossAxisAlignment.start)
                                                      .flutterValue,
                                              textBaseline:
                                                  TextBaseline.alphabetic,
                                              children: [
                                                Text(
                                                  'Size (optional)',
                                                  style:
                                                      FlutterFlowTheme.of(
                                                        context,
                                                      ).bodyMedium.override(
                                                        font: GoogleFonts.montserrat(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                    context,
                                                                  )
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                              context,
                                                            ).primaryBackground,
                                                        fontSize: 13.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsetsDirectional.fromSTEB(
                                                        3.0,
                                                        0.0,
                                                        0.0,
                                                        0.0,
                                                      ),
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 56.0,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                            context,
                                                          ).primaryText,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12.0,
                                                          ),
                                                      border: Border.all(
                                                        color: Color(
                                                          0xFFD9D9D9,
                                                        ),
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                    alignment:
                                                        AlignmentDirectional(
                                                          0.0,
                                                          0.0,
                                                        ),
                                                    child: Container(
                                                      width: double.infinity,
                                                      child: TextFormField(
                                                        controller: _model
                                                            .textController3,
                                                        focusNode: _model
                                                            .textFieldFocusNode3,
                                                        autofocus: false,
                                                        enabled: true,
                                                        obscureText: false,
                                                        decoration: InputDecoration(
                                                          isDense: true,
                                                          labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                            font: GoogleFonts.inter(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .labelMedium
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .labelMedium
                                                                      .fontStyle,
                                                            ),
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .labelMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .labelMedium
                                                                    .fontStyle,
                                                          ),
                                                          hintText: 'Enter size or amount',
                                                          hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                            font: GoogleFonts.inter(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .labelMedium
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .labelMedium
                                                                      .fontStyle,
                                                            ),
                                                            color: Color(
                                                              0xFFBABABA,
                                                            ),
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .labelMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .labelMedium
                                                                    .fontStyle,
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                      color: Color(
                                                                        0x00000000,
                                                                      ),
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8.0,
                                                                    ),
                                                              ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                      color: Color(
                                                                        0x00000000,
                                                                      ),
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8.0,
                                                                    ),
                                                              ),
                                                          errorBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                              color:
                                                                  FlutterFlowTheme.of(
                                                                    context,
                                                                  ).error,
                                                              width: 1.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8.0,
                                                                ),
                                                          ),
                                                          focusedErrorBorder:
                                                              OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color:
                                                                      FlutterFlowTheme.of(
                                                                        context,
                                                                      ).error,
                                                                  width: 1.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8.0,
                                                                    ),
                                                              ),
                                                          filled: true,
                                                          fillColor:
                                                              FlutterFlowTheme.of(
                                                                context,
                                                              ).primaryText,
                                                        ),
                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          font: GoogleFonts.inter(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color:
                                                              FlutterFlowTheme.of(
                                                                context,
                                                              ).primaryBackground,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                    context,
                                                                  )
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                    context,
                                                                  )
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        maxLines: null,
                                                        cursorColor:
                                                            FlutterFlowTheme.of(
                                                              context,
                                                            ).primaryText,
                                                        enableInteractiveSelection:
                                                            true,
                                                        validator: _model
                                                            .textController3Validator
                                                            .asValidator(
                                                              context,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ].divide(SizedBox(height: 10.0)),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  (FFCrossAxisAlignment.start)
                                                      .flutterValue,
                                              textBaseline:
                                                  TextBaseline.alphabetic,
                                              children: [
                                                Text(
                                                  'Quantity (optional)',
                                                  style:
                                                      FlutterFlowTheme.of(
                                                        context,
                                                      ).bodyMedium.override(
                                                        font: GoogleFonts.montserrat(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                    context,
                                                                  )
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                              context,
                                                            ).primaryBackground,
                                                        fontSize: 13.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Padding(
                                                  padding:
                                                      EdgeInsetsDirectional.fromSTEB(
                                                        3.0,
                                                        0.0,
                                                        0.0,
                                                        0.0,
                                                      ),
                                                  child: Container(
                                                    width: double.infinity,
                                                    height: 56.0,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          FlutterFlowTheme.of(
                                                            context,
                                                          ).primaryText,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            12.0,
                                                          ),
                                                      border: Border.all(
                                                        color: Color(
                                                          0xFFD9D9D9,
                                                        ),
                                                        width: 1.0,
                                                      ),
                                                    ),
                                                    alignment:
                                                        AlignmentDirectional(
                                                          0.0,
                                                          0.0,
                                                        ),
                                                    child: Container(
                                                      width: double.infinity,
                                                      child: TextFormField(
                                                        controller: _model
                                                            .textController4,
                                                        focusNode: _model
                                                            .textFieldFocusNode4,
                                                        autofocus: false,
                                                        enabled: true,
                                                        obscureText: false,
                                                        decoration: InputDecoration(
                                                          isDense: true,
                                                          labelStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                            font: GoogleFonts.inter(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .labelMedium
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .labelMedium
                                                                      .fontStyle,
                                                            ),
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .labelMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .labelMedium
                                                                    .fontStyle,
                                                          ),
                                                          hintText: 'How many you have',
                                                          hintStyle: FlutterFlowTheme.of(context).labelMedium.override(
                                                            font: GoogleFonts.inter(
                                                              fontWeight:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .labelMedium
                                                                      .fontWeight,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .labelMedium
                                                                      .fontStyle,
                                                            ),
                                                            color: Color(
                                                              0xFFBABABA,
                                                            ),
                                                            letterSpacing: 0.0,
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .labelMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .labelMedium
                                                                    .fontStyle,
                                                          ),
                                                          enabledBorder:
                                                              OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                      color: Color(
                                                                        0x00000000,
                                                                      ),
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8.0,
                                                                    ),
                                                              ),
                                                          focusedBorder:
                                                              OutlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                      color: Color(
                                                                        0x00000000,
                                                                      ),
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8.0,
                                                                    ),
                                                              ),
                                                          errorBorder: OutlineInputBorder(
                                                            borderSide: BorderSide(
                                                              color:
                                                                  FlutterFlowTheme.of(
                                                                    context,
                                                                  ).error,
                                                              width: 1.0,
                                                            ),
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8.0,
                                                                ),
                                                          ),
                                                          focusedErrorBorder:
                                                              OutlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color:
                                                                      FlutterFlowTheme.of(
                                                                        context,
                                                                      ).error,
                                                                  width: 1.0,
                                                                ),
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                      8.0,
                                                                    ),
                                                              ),
                                                          filled: true,
                                                          fillColor:
                                                              FlutterFlowTheme.of(
                                                                context,
                                                              ).primaryText,
                                                        ),
                                                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                          font: GoogleFonts.inter(
                                                            fontWeight:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .bodyMedium
                                                                    .fontWeight,
                                                            fontStyle:
                                                                FlutterFlowTheme.of(
                                                                      context,
                                                                    )
                                                                    .bodyMedium
                                                                    .fontStyle,
                                                          ),
                                                          color:
                                                              FlutterFlowTheme.of(
                                                                context,
                                                              ).primaryBackground,
                                                          letterSpacing: 0.0,
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                    context,
                                                                  )
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                    context,
                                                                  )
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        maxLines: null,
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        cursorColor:
                                                            FlutterFlowTheme.of(
                                                              context,
                                                            ).primaryText,
                                                        enableInteractiveSelection:
                                                            true,
                                                        validator: _model
                                                            .textController4Validator
                                                            .asValidator(
                                                              context,
                                                            ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Text(
                                                  'Only you see this count. At 0 the product shows as out of stock.',
                                                  style:
                                                      FlutterFlowTheme.of(
                                                        context,
                                                      ).bodyMedium.override(
                                                        font: GoogleFonts.montserrat(
                                                          fontWeight:
                                                              FlutterFlowTheme.of(
                                                                    context,
                                                                  )
                                                                  .bodyMedium
                                                                  .fontWeight,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                    context,
                                                                  )
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color: Color(
                                                          0x74000000,
                                                        ),
                                                        fontSize: 12.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .bodyMedium
                                                                .fontWeight,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                              ].divide(SizedBox(height: 10.0)),
                                            ),
                                          ),
                                          Container(
                                            decoration: BoxDecoration(),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.max,
                                              crossAxisAlignment:
                                                  (FFCrossAxisAlignment.start)
                                                      .flutterValue,
                                              children: [
                                                Text(
                                                  'Availability',
                                                  style:
                                                      FlutterFlowTheme.of(
                                                        context,
                                                      ).bodyMedium.override(
                                                        font: GoogleFonts.montserrat(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontStyle:
                                                              FlutterFlowTheme.of(
                                                                    context,
                                                                  )
                                                                  .bodyMedium
                                                                  .fontStyle,
                                                        ),
                                                        color:
                                                            FlutterFlowTheme.of(
                                                              context,
                                                            ).primaryBackground,
                                                        fontSize: 13.0,
                                                        letterSpacing: 0.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                ),
                                                Row(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  children: [
                                                    InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        _model.outOfStock =
                                                            false;
                                                        safeSetState(() {});
                                                        if (_model
                                                                .textController4
                                                                .text ==
                                                            '0') {
                                                          safeSetState(() {
                                                            _model
                                                                .textController4
                                                                ?.clear();
                                                          });
                                                        }
                                                      },
                                                      child: Container(
                                                        height: 40.0,
                                                        decoration: BoxDecoration(
                                                          color: functions
                                                              .choiceChipFill(
                                                                _model
                                                                    .outOfStock,
                                                                false,
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                100.0,
                                                              ),
                                                          border: Border.all(
                                                            color: Color(
                                                              0xFFD9D9D9,
                                                            ),
                                                            width: 1.0,
                                                          ),
                                                        ),
                                                        alignment:
                                                            AlignmentDirectional(
                                                              0.0,
                                                              0.0,
                                                            ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional.fromSTEB(
                                                                18.0,
                                                                0.0,
                                                                18.0,
                                                                0.0,
                                                              ),
                                                          child: Text(
                                                            'In stock',
                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                              font: GoogleFonts.montserrat(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontStyle:
                                                                    FlutterFlowTheme.of(
                                                                          context,
                                                                        )
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                              ),
                                                              color: functions
                                                                  .choiceChipText(
                                                                    _model
                                                                        .outOfStock,
                                                                    false,
                                                                  ),
                                                              fontSize: 13.0,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    InkWell(
                                                      splashColor:
                                                          Colors.transparent,
                                                      focusColor:
                                                          Colors.transparent,
                                                      hoverColor:
                                                          Colors.transparent,
                                                      highlightColor:
                                                          Colors.transparent,
                                                      onTap: () async {
                                                        _model.outOfStock =
                                                            true;
                                                        safeSetState(() {});
                                                        safeSetState(() {
                                                          _model
                                                                  .textController4
                                                                  ?.text =
                                                              '0';
                                                        });
                                                      },
                                                      child: Container(
                                                        height: 40.0,
                                                        decoration: BoxDecoration(
                                                          color: functions
                                                              .choiceChipFill(
                                                                _model
                                                                    .outOfStock,
                                                                true,
                                                              ),
                                                          borderRadius:
                                                              BorderRadius.circular(
                                                                100.0,
                                                              ),
                                                          border: Border.all(
                                                            color: Color(
                                                              0xFFD9D9D9,
                                                            ),
                                                            width: 1.0,
                                                          ),
                                                        ),
                                                        alignment:
                                                            AlignmentDirectional(
                                                              0.0,
                                                              0.0,
                                                            ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional.fromSTEB(
                                                                18.0,
                                                                0.0,
                                                                18.0,
                                                                0.0,
                                                              ),
                                                          child: Text(
                                                            'Out of stock',
                                                            style: FlutterFlowTheme.of(context).bodyMedium.override(
                                                              font: GoogleFonts.montserrat(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontStyle:
                                                                    FlutterFlowTheme.of(
                                                                          context,
                                                                        )
                                                                        .bodyMedium
                                                                        .fontStyle,
                                                              ),
                                                              color: functions
                                                                  .choiceChipText(
                                                                    _model
                                                                        .outOfStock,
                                                                    true,
                                                                  ),
                                                              fontSize: 13.0,
                                                              letterSpacing:
                                                                  0.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontStyle:
                                                                  FlutterFlowTheme.of(
                                                                        context,
                                                                      )
                                                                      .bodyMedium
                                                                      .fontStyle,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ].divide(SizedBox(width: 10.0)),
                                                ),
                                              ].divide(SizedBox(height: 10.0)),
                                            ),
                                          ),
                                          Padding(
                                            padding:
                                                EdgeInsetsDirectional.fromSTEB(
                                                  0.0,
                                                  10.0,
                                                  0.0,
                                                  0.0,
                                                ),
                                            child: InkWell(
                                              splashColor: Colors.transparent,
                                              focusColor: Colors.transparent,
                                              hoverColor: Colors.transparent,
                                              highlightColor:
                                                  Colors.transparent,
                                              onTap: () async {
                                                await showModalBottomSheet(
                                                  isScrollControlled: true,
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  enableDrag: false,
                                                  context: context,
                                                  builder: (context) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        FocusScope.of(context)
                                                            .unfocus();
                                                        FocusManager
                                                            .instance
                                                            .primaryFocus
                                                            ?.unfocus();
                                                      },
                                                      child: Padding(
                                                        padding:
                                                            MediaQuery.viewInsetsOf(
                                                              context,
                                                            ),
                                                        child:
                                                            DeleteProductSheetWidget(
                                                              productId:
                                                                  getJsonField(
                                                                    widget!
                                                                        .product,
                                                                    r'''$.id''',
                                                                  ).toString(),
                                                              name: getJsonField(
                                                                widget!.product,
                                                                r'''$.name''',
                                                              ).toString(),
                                                            ),
                                                      ),
                                                    );
                                                  },
                                                ).then(
                                                  (value) => safeSetState(
                                                    () =>
                                                        _model.deleted = value,
                                                  ),
                                                );

                                                if (_model.deleted == true) {
                                                  context.safePop();
                                                }

                                                safeSetState(() {});
                                              },
                                              child: Text(
                                                'Delete product',
                                                style:
                                                    FlutterFlowTheme.of(
                                                      context,
                                                    ).bodyMedium.override(
                                                      font: GoogleFonts.montserrat(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontStyle:
                                                            FlutterFlowTheme.of(
                                                                  context,
                                                                )
                                                                .bodyMedium
                                                                .fontStyle,
                                                      ),
                                                      color: Color(0xFFFF3128),
                                                      fontSize: 14.0,
                                                      letterSpacing: 0.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontStyle:
                                                          FlutterFlowTheme.of(
                                                                context,
                                                              )
                                                              .bodyMedium
                                                              .fontStyle,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ].divide(SizedBox(height: 15.0)),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsetsDirectional.fromSTEB(
                          15.0,
                          0.0,
                          15.0,
                          35.0,
                        ),
                        child: InkWell(
                          splashColor: Colors.transparent,
                          focusColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          onTap: () async {
                            if (_model.saving) {
                              return;
                            }
                            _model.formError = functions.productFormError(
                              _model.textController1.text,
                              _model.textController2.text,
                              _model.textController3.text,
                              _model.textController4.text,
                              _model.outOfStock,
                            );
                            if (_model.formError != '') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    _model.formError,
                                    style: TextStyle(),
                                  ),
                                  duration: Duration(milliseconds: 4000),
                                ),
                              );
                              return;
                            }
                            _model.saving = true;
                            safeSetState(() {});
                            _model.token = await actions.haatAccessToken();
                            _model.updateResult = await HaatAuthGroup
                                .updateProductCall
                                .call(
                                  productId: getJsonField(
                                    widget!.product,
                                    r'''$.id''',
                                  ).toString(),
                                  name: _model.textController1.text,
                                  unit: _model.textController3.text,
                                  priceMinor: functions.priceToMinor(
                                    _model.textController2.text,
                                  ),
                                  quantity: functions.productQuantity(
                                    _model.textController4.text,
                                    _model.outOfStock,
                                  ),
                                  accessToken: _model.token,
                                );

                            if ((_model.updateResult?.succeeded ?? true)) {
                              if (_model.photo != null &&
                                  (_model.photo?.bytes?.isNotEmpty ?? false)) {
                                _model.uploadResult = await HaatAuthGroup
                                    .uploadProductImageCall
                                    .call(
                                      productId: getJsonField(
                                        widget!.product,
                                        r'''$.id''',
                                      ).toString(),
                                      file: _model.photo,
                                      accessToken: _model.token,
                                    );

                                if (!(_model.uploadResult?.succeeded ?? true)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Your changes were saved, but the new photo was not. ${HaatAuthGroup.uploadProductImageCall.message((_model.uploadResult?.jsonBody ?? ''))}',
                                        style: TextStyle(),
                                      ),
                                      duration: Duration(milliseconds: 4000),
                                    ),
                                  );
                                }
                              }
                              _model.saving = false;
                              safeSetState(() {});
                              context.safePop();
                            } else {
                              _model.saving = false;
                              safeSetState(() {});
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    valueOrDefault<String>(
                                      HaatAuthGroup.updateProductCall.message(
                                        (_model.updateResult?.jsonBody ?? ''),
                                      ),
                                      'Your changes could not be saved. Try again.',
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
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: FlutterFlowTheme.of(context)
                                  .primaryBackground,
                              borderRadius: BorderRadius.circular(106.67),
                            ),
                            alignment: AlignmentDirectional(0.0, 0.0),
                            child: Text(
                              _model.saving ? 'Saving…' : 'Save changes',
                              style: FlutterFlowTheme.of(context).bodyMedium
                                  .override(
                                    font: GoogleFonts.montserrat(
                                      fontWeight: FontWeight.bold,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .bodyMedium
                                          .fontStyle,
                                    ),
                                    color: FlutterFlowTheme.of(context)
                                        .primaryText,
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
                      ),
                    ],
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
