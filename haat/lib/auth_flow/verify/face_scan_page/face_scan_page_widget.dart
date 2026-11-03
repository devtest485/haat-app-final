import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'face_scan_page_model.dart';
export 'face_scan_page_model.dart';

class FaceScanPageWidget extends StatefulWidget {
  const FaceScanPageWidget({super.key});

  static String routeName = 'FaceScanPage';
  static String routePath = '/faceScanPage';

  @override
  State<FaceScanPageWidget> createState() => _FaceScanPageWidgetState();
}

class _FaceScanPageWidgetState extends State<FaceScanPageWidget> {
  late FaceScanPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => FaceScanPageModel());
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
          decoration: BoxDecoration(),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: custom_widgets.FaceScanner(
              width: double.infinity,
              height: double.infinity,
              title: 'ID Scanning',
              showBackButton: true,
              useFrontCamera: true,
              mirrorPreview: true,
              dimOutsideOval: true,
              onCaptured: (imagePath) async {
                context.pushNamed(BusinessInfoWidget.routeName);
              },
              onClose: () async {
                context.pushNamed(BusinessInfoWidget.routeName);
              },
            ),
          ),
        ),
      ),
    );
  }
}
