import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'welcome_motion_model.dart';
export 'welcome_motion_model.dart';

/// The app's entry route. It has nothing on it to look at: it asks where the user
/// belongs and sends them there, and a first run with no session goes straight
/// to the onboarding pages.
class WelcomeMotionWidget extends StatefulWidget {
  const WelcomeMotionWidget({super.key});

  static String routeName = 'WelcomeMotion';
  static String routePath = '/welcomeMotion';

  @override
  State<WelcomeMotionWidget> createState() => _WelcomeMotionWidgetState();
}

class _WelcomeMotionWidgetState extends State<WelcomeMotionWidget> {
  late WelcomeMotionModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => WelcomeMotionModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      _model.startupRoute = await actions.haatStartupRoute();
      if (_model.startupRoute == 'passcode') {
        context.goNamed(PassCodeLoginWidget.routeName);
      } else if (_model.startupRoute == 'login') {
        context.goNamed(LoginScreenWidget.routeName);
      } else if (_model.startupRoute == 'createPassword') {
        context.goNamed(CreatePasswordPageWidget.routeName);
      } else if (_model.startupRoute == 'securePage') {
        context.goNamed(SecurePageWidget.routeName);
      } else if (_model.startupRoute == 'username') {
        context.goNamed(UsernamePageWidget.routeName);
      } else if (_model.startupRoute == 'home') {
        context.goNamed(BottomBarPagesWidget.routeName);
      } else if (_model.startupRoute == 'welcome') {
        context.goNamed(OnBoardingPageWidget.routeName);
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.black,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
        ),
      ),
    );
  }
}
