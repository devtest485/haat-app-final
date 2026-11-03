import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'id_card_scan_page_model.dart';
export 'id_card_scan_page_model.dart';

class IdCardScanPageWidget extends StatefulWidget {
  const IdCardScanPageWidget({super.key});

  static String routeName = 'IdCardScanPage';
  static String routePath = '/idCardScanPage';

  @override
  State<IdCardScanPageWidget> createState() => _IdCardScanPageWidgetState();
}

class _IdCardScanPageWidgetState extends State<IdCardScanPageWidget> {
  late IdCardScanPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => IdCardScanPageModel());
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
            child: custom_widgets.IdDocumentScanner(
              width: double.infinity,
              height: double.infinity,
              title: 'ID Scanning',
              showTipsOnOpen: true,
              showBackButton: true,
              frameAspectRatio: 200.0,
              sheetTitle: 'Prepare to scan document',
              tipsCardText: 'Scanning tips',
              tip1:
                  'Verify that all details on your document are clear and not blurry.',
              tip2:
                  'Ensure well-lit surroundings to prevent shadows from obscuring the data.',
              tip3:
                  'Avoid using a flash, as it may make it challenging to read the information.',
              tip4:
                  'Ensure your fingers do not cover any data, the document must fit within the frame.',
              okButtonText: 'Ok',
              onCaptured: (imagePath) async {
                context.pushNamed(SelfiInfoWidget.routeName);
              },
              onClose: () async {
                context.pushNamed(SelfiInfoWidget.routeName);
              },
            ),
          ),
        ),
      ),
    );
  }
}
