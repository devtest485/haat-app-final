import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'congrats_page_model.dart';
export 'congrats_page_model.dart';

class CongratsPageWidget extends StatefulWidget {
  const CongratsPageWidget({
    super.key,
    required this.userName,
  });

  final String? userName;

  static String routeName = 'CongratsPage';
  static String routePath = '/congratsPage';

  @override
  State<CongratsPageWidget> createState() => _CongratsPageWidgetState();
}

class _CongratsPageWidgetState extends State<CongratsPageWidget> {
  late CongratsPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CongratsPageModel());
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
            color: Colors.black,
          ),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            child: custom_widgets.NamePatternBackground(
              width: double.infinity,
              height: double.infinity,
              name: widget!.userName,
              fallbackName: '',
              textColor: FlutterFlowTheme.of(context).tertiary,
              backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
              fadeColor: Color(0x40000000),
              fontWeight: 800,
              mirrorAlternate: true,
              lowercase: true,
              animate: false,
              showContent: true,
              onButtonTap: () async {
                context.pushNamed(DocunmentInfoWidget.routeName);
              },
            ),
          ),
        ),
      ),
    );
  }
}
