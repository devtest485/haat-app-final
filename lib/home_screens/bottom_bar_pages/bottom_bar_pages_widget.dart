import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/home_screens/home_screen/home_screen_widget.dart';
import '/home_screens/new_order_flow/add_amount_view/add_amount_view_widget.dart';
import '/marketplace/market_place/market_place_widget.dart';
import '/my_store/store_profile/store_profile_widget.dart';
import '/custom_code/actions/index.dart' as actions;
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'bottom_bar_pages_model.dart';
export 'bottom_bar_pages_model.dart';

class BottomBarPagesWidget extends StatefulWidget {
  const BottomBarPagesWidget({super.key});

  static String routeName = 'BottomBarPages';
  static String routePath = '/bottomBarPages';

  @override
  State<BottomBarPagesWidget> createState() => _BottomBarPagesWidgetState();
}

class _BottomBarPagesWidgetState extends State<BottomBarPagesWidget> {
  late BottomBarPagesModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => BottomBarPagesModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      FFAppState().hasLoggedInBefore = true;
      safeSetState(() {});
      await actions.haatLoadProfile();
    });
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
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Align(
          alignment: AlignmentDirectional(0.0, 1.0),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              child: custom_widgets.CustomBottombar(
                width: double.infinity,
                height: double.infinity,
                homeLabel: 'Home',
                cashierLabel: 'Cashier',
                servicesLabel: 'Marketplace',
                storeLabel: 'Profile',
                labelSize: 11.0,
                initialIndex: 0,
                extendBodyBehindBar: true,
                enableScrolling: false,
                onTabChanged: (tabIndex) async {
                  safeSetState(() {});
                },
                homePage: () => HomeScreenWidget(),
                cashierPage: () => AddAmountViewWidget(
                  startOnCashier: true,
                ),
                servicesPage: () => MarketPlaceWidget(),
                storePage: () => StoreProfileWidget(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
