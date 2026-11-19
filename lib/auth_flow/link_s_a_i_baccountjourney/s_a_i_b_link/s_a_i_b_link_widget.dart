import '/components/country_picker_widget.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 's_a_i_b_link_model.dart';
export 's_a_i_b_link_model.dart';

class SAIBLinkWidget extends StatefulWidget {
  const SAIBLinkWidget({super.key});

  static String routeName = 'SAIBLink';
  static String routePath = '/sAIBLink';

  @override
  State<SAIBLinkWidget> createState() => _SAIBLinkWidgetState();
}

class _SAIBLinkWidgetState extends State<SAIBLinkWidget> {
  late SAIBLinkModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SAIBLinkModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: FFAppState().saibLight
            ? FlutterFlowTheme.of(context).secondaryBackground
            : Colors.black,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: FFAppState().saibLight
                ? FlutterFlowTheme.of(context).secondaryBackground
                : Colors.black,
          ),
          child: custom_widgets.SaibLinkFlow(
            width: double.infinity,
            height: double.infinity,
            light: FFAppState().saibLight,
            onPickCountry: () async {
              await showModalBottomSheet(
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) {
                  return Padding(
                    padding: MediaQuery.viewInsetsOf(context),
                    child: Container(
                      height: MediaQuery.sizeOf(context).height * 0.82,
                      child: CountryPickerWidget(
                        dark: !FFAppState().saibLight,
                        target: 'saib',
                      ),
                    ),
                  );
                },
              ).then((value) => safeSetState(() {}));
            },
            onBack: () async {
              context.safePop();
            },
            onNotFound: () async {
              context.pushNamed(SAIBNotFoundWidget.routeName);
            },
            onDone: () async {
              context.goNamed(BottomBarPagesWidget.routeName);
            },
          ),
        ),
      ),
    );
  }
}
