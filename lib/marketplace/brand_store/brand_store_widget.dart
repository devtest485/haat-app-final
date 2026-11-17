import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/my_store/store/store_widget.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'brand_store_model.dart';
export 'brand_store_model.dart';

class BrandStoreWidget extends StatefulWidget {
  const BrandStoreWidget({
    super.key,
    this.brandName,
    this.description,
    this.logoUrl,
    this.brandColor,
  });

  final String? brandName;
  final String? description;
  final String? logoUrl;
  final String? brandColor;

  static String routeName = 'BrandStore';
  static String routePath = '/brandStore';

  @override
  State<BrandStoreWidget> createState() => _BrandStoreWidgetState();
}

class _BrandStoreWidgetState extends State<BrandStoreWidget> {
  late BrandStoreModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BrandStoreModel());
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
        body: Stack(
          children: [
            wrapWithModel(
              model: _model.storeModel,
              updateCallback: () => safeSetState(() {}),
              child: StoreWidget(
                brandName: widget!.brandName,
                description: widget!.description,
                logoUrl: widget!.logoUrl,
                brandColor: widget!.brandColor,
                onSell: () async {
                  context.pushNamed(
                    RequestSuccessWidget.routeName,
                    queryParameters: {
                      'standReference': serializeParam(
                        functions.brandRequestReference(),
                        ParamType.String,
                      ),
                    }.withoutNulls,
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(16.0, 48.0, 0.0, 0.0),
              child: Container(
                child: InkWell(
                  splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  hoverColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onTap: () async {
                    context.safePop();
                  },
                  child: Container(
                    width: 40.0,
                    height: 40.0,
                    alignment: AlignmentDirectional(0.0, 0.0),
                    child: Icon(
                      Icons.arrow_back_ios_new,
                      color: FlutterFlowTheme.of(context).primaryBackground,
                      size: 24.0,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
