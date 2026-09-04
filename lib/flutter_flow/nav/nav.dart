import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

import '/main.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/lat_lng.dart';
import '/flutter_flow/place.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'serialization_util.dart';

import '/index.dart';

export 'package:go_router/go_router.dart';
export 'serialization_util.dart';

const kTransitionInfoKey = '__transition_info__';

GlobalKey<NavigatorState> appNavigatorKey = GlobalKey<NavigatorState>();

class AppStateNotifier extends ChangeNotifier {
  AppStateNotifier._();

  static AppStateNotifier? _instance;
  static AppStateNotifier get instance => _instance ??= AppStateNotifier._();

  bool showSplashImage = true;

  void stopShowingSplashImage() {
    showSplashImage = false;
    notifyListeners();
  }
}

GoRouter createRouter(AppStateNotifier appStateNotifier) => GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      refreshListenable: appStateNotifier,
      navigatorKey: appNavigatorKey,
      errorBuilder: (context, state) => OnBoardingPageWidget(),
      routes: [
        FFRoute(
          name: '_initialize',
          path: '/',
          builder: (context, _) => OnBoardingPageWidget(),
        ),
        FFRoute(
          name: OnBoardingPageWidget.routeName,
          path: OnBoardingPageWidget.routePath,
          builder: (context, params) => OnBoardingPageWidget(),
        ),
        FFRoute(
          name: PhoneNumberPageWidget.routeName,
          path: PhoneNumberPageWidget.routePath,
          builder: (context, params) => PhoneNumberPageWidget(),
        ),
        FFRoute(
          name: SignInPageWidget.routeName,
          path: SignInPageWidget.routePath,
          builder: (context, params) => const SignInPageWidget(),
        ),
        FFRoute(
          name: OtpVerifyPageWidget.routeName,
          path: OtpVerifyPageWidget.routePath,
          builder: (context, params) => OtpVerifyPageWidget(
            phoneNum: params.getParam(
              'phoneNum',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: CreatePasswordPageWidget.routeName,
          path: CreatePasswordPageWidget.routePath,
          builder: (context, params) => CreatePasswordPageWidget(),
        ),
        FFRoute(
          name: SecurePageWidget.routeName,
          path: SecurePageWidget.routePath,
          builder: (context, params) => SecurePageWidget(),
        ),
        FFRoute(
          name: PassCodePageWidget.routeName,
          path: PassCodePageWidget.routePath,
          builder: (context, params) => PassCodePageWidget(),
        ),
        FFRoute(
          name: BiomatricPageWidget.routeName,
          path: BiomatricPageWidget.routePath,
          builder: (context, params) => BiomatricPageWidget(),
        ),
        FFRoute(
          name: VerifyPageWidget.routeName,
          path: VerifyPageWidget.routePath,
          builder: (context, params) => VerifyPageWidget(),
        ),
        FFRoute(
          name: ChooseDocumentPageWidget.routeName,
          path: ChooseDocumentPageWidget.routePath,
          builder: (context, params) => ChooseDocumentPageWidget(),
        ),
        FFRoute(
          name: IdCardScanPageWidget.routeName,
          path: IdCardScanPageWidget.routePath,
          builder: (context, params) => IdCardScanPageWidget(),
        ),
        FFRoute(
          name: FaceScanPageWidget.routeName,
          path: FaceScanPageWidget.routePath,
          builder: (context, params) => FaceScanPageWidget(),
        ),
        FFRoute(
          name: SelfiInfoWidget.routeName,
          path: SelfiInfoWidget.routePath,
          builder: (context, params) => SelfiInfoWidget(),
        ),
        FFRoute(
          name: BusinessInfoWidget.routeName,
          path: BusinessInfoWidget.routePath,
          builder: (context, params) => BusinessInfoWidget(),
        ),
        FFRoute(
          name: LikeBusPageWidget.routeName,
          path: LikeBusPageWidget.routePath,
          builder: (context, params) => LikeBusPageWidget(),
        ),
        FFRoute(
          name: BusinessCatageriousWidget.routeName,
          path: BusinessCatageriousWidget.routePath,
          builder: (context, params) => BusinessCatageriousWidget(),
        ),
        FFRoute(
          name: SetupBisinessLocationPageWidget.routeName,
          path: SetupBisinessLocationPageWidget.routePath,
          builder: (context, params) => SetupBisinessLocationPageWidget(),
        ),
        FFRoute(
          name: BusinessLocatePageWidget.routeName,
          path: BusinessLocatePageWidget.routePath,
          builder: (context, params) => BusinessLocatePageWidget(),
        ),
        FFRoute(
          name: UsernamePageWidget.routeName,
          path: UsernamePageWidget.routePath,
          builder: (context, params) => UsernamePageWidget(),
        ),
        FFRoute(
          name: CongratsPageWidget.routeName,
          path: CongratsPageWidget.routePath,
          builder: (context, params) => CongratsPageWidget(
            userName: params.getParam(
              'userName',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: DocunmentInfoWidget.routeName,
          path: DocunmentInfoWidget.routePath,
          builder: (context, params) => DocunmentInfoWidget(),
        ),
        FFRoute(
          name: UploadDocWidget.routeName,
          path: UploadDocWidget.routePath,
          builder: (context, params) => UploadDocWidget(),
        ),
        FFRoute(
          name: AddAmountPageWidget.routeName,
          path: AddAmountPageWidget.routePath,
          builder: (context, params) => AddAmountPageWidget(),
        ),
        FFRoute(
          name: TapPayOutWidget.routeName,
          path: TapPayOutWidget.routePath,
          builder: (context, params) => TapPayOutWidget(),
        ),
        FFRoute(
          name: QRpayOutPageWidget.routeName,
          path: QRpayOutPageWidget.routePath,
          builder: (context, params) => QRpayOutPageWidget(),
        ),
        FFRoute(
          name: LinkPayOutPageWidget.routeName,
          path: LinkPayOutPageWidget.routePath,
          builder: (context, params) => LinkPayOutPageWidget(),
        ),
        FFRoute(
          name: BottomBarPagesWidget.routeName,
          path: BottomBarPagesWidget.routePath,
          builder: (context, params) => BottomBarPagesWidget(),
        ),
        FFRoute(
          name: DeliveryLocationWidget.routeName,
          path: DeliveryLocationWidget.routePath,
          builder: (context, params) => DeliveryLocationWidget(),
        ),
        FFRoute(
          name: RequestSuccessWidget.routeName,
          path: RequestSuccessWidget.routePath,
          builder: (context, params) => RequestSuccessWidget(),
        ),
        FFRoute(
          name: AddEmployeesWidget.routeName,
          path: AddEmployeesWidget.routePath,
          builder: (context, params) => AddEmployeesWidget(),
        ),
        FFRoute(
          name: AddEmpoleyNameWidget.routeName,
          path: AddEmpoleyNameWidget.routePath,
          builder: (context, params) => AddEmpoleyNameWidget(),
        ),
        FFRoute(
          name: SelectBranchWidget.routeName,
          path: SelectBranchWidget.routePath,
          builder: (context, params) => SelectBranchWidget(),
        ),
        FFRoute(
          name: EmpoleyRoleWidget.routeName,
          path: EmpoleyRoleWidget.routePath,
          builder: (context, params) => EmpoleyRoleWidget(),
        ),
        FFRoute(
          name: ReviewDetailsWidget.routeName,
          path: ReviewDetailsWidget.routePath,
          builder: (context, params) => ReviewDetailsWidget(),
        ),
        FFRoute(
          name: CreatingProfileWidget.routeName,
          path: CreatingProfileWidget.routePath,
          builder: (context, params) => CreatingProfileWidget(),
        ),
        FFRoute(
          name: EmployeDetailsWidget.routeName,
          path: EmployeDetailsWidget.routePath,
          builder: (context, params) => EmployeDetailsWidget(),
        ),
        FFRoute(
          name: AddFundWidget.routeName,
          path: AddFundWidget.routePath,
          builder: (context, params) => AddFundWidget(
            fund: params.getParam(
              'fund',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: BankOTPVerificationWidget.routeName,
          path: BankOTPVerificationWidget.routePath,
          builder: (context, params) => BankOTPVerificationWidget(),
        ),
        FFRoute(
          name: OtherBanksWidget.routeName,
          path: OtherBanksWidget.routePath,
          builder: (context, params) => OtherBanksWidget(),
        ),
        FFRoute(
          name: BankDetialsWidget.routeName,
          path: BankDetialsWidget.routePath,
          builder: (context, params) => BankDetialsWidget(),
        ),
        FFRoute(
          name: PaymentStatusWidget.routeName,
          path: PaymentStatusWidget.routePath,
          builder: (context, params) => PaymentStatusWidget(
            paymentStatus: params.getParam(
              'paymentStatus',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: TransfermethodWidget.routeName,
          path: TransfermethodWidget.routePath,
          builder: (context, params) => TransfermethodWidget(
            transferMode: params.getParam(
              'transferMode',
              ParamType.String,
            ),
          ),
        ),
        FFRoute(
          name: PaymentReviewWidget.routeName,
          path: PaymentReviewWidget.routePath,
          builder: (context, params) => PaymentReviewWidget(),
        )
      ].map((r) => r.toRoute(appStateNotifier)).toList(),
    );

extension NavParamExtensions on Map<String, String?> {
  Map<String, String> get withoutNulls => Map.fromEntries(
        entries
            .where((e) => e.value != null)
            .map((e) => MapEntry(e.key, e.value!)),
      );
}

extension NavigationExtensions on BuildContext {
  void safePop() {
    // If there is only one route on the stack, navigate to the initial
    // page instead of popping.
    if (canPop()) {
      pop();
    } else {
      go('/');
    }
  }
}

extension _GoRouterStateExtensions on GoRouterState {
  Map<String, dynamic> get extraMap =>
      extra != null ? extra as Map<String, dynamic> : {};
  Map<String, dynamic> get allParams => <String, dynamic>{}
    ..addAll(pathParameters)
    ..addAll(uri.queryParameters)
    ..addAll(extraMap);
  TransitionInfo get transitionInfo => extraMap.containsKey(kTransitionInfoKey)
      ? extraMap[kTransitionInfoKey] as TransitionInfo
      : TransitionInfo.appDefault();
}

class FFParameters {
  FFParameters(this.state, [this.asyncParams = const {}]);

  final GoRouterState state;
  final Map<String, Future<dynamic> Function(String)> asyncParams;

  Map<String, dynamic> futureParamValues = {};

  // Parameters are empty if the params map is empty or if the only parameter
  // present is the special extra parameter reserved for the transition info.
  bool get isEmpty =>
      state.allParams.isEmpty ||
      (state.allParams.length == 1 &&
          state.extraMap.containsKey(kTransitionInfoKey));
  bool isAsyncParam(MapEntry<String, dynamic> param) =>
      asyncParams.containsKey(param.key) && param.value is String;
  bool get hasFutures => state.allParams.entries.any(isAsyncParam);
  Future<bool> completeFutures() => Future.wait(
        state.allParams.entries.where(isAsyncParam).map(
          (param) async {
            final doc = await asyncParams[param.key]!(param.value)
                .onError((_, __) => null);
            if (doc != null) {
              futureParamValues[param.key] = doc;
              return true;
            }
            return false;
          },
        ),
      ).onError((_, __) => [false]).then((v) => v.every((e) => e));

  dynamic getParam<T>(
    String paramName,
    ParamType type, {
    bool isList = false,
  }) {
    if (futureParamValues.containsKey(paramName)) {
      return futureParamValues[paramName];
    }
    if (!state.allParams.containsKey(paramName)) {
      return null;
    }
    final param = state.allParams[paramName];
    // Got parameter from `extras`, so just directly return it.
    if (param is! String) {
      return param;
    }
    // Return serialized value.
    return deserializeParam<T>(
      param,
      type,
      isList,
    );
  }
}

class FFRoute {
  const FFRoute({
    required this.name,
    required this.path,
    required this.builder,
    this.requireAuth = false,
    this.asyncParams = const {},
    this.routes = const [],
  });

  final String name;
  final String path;
  final bool requireAuth;
  final Map<String, Future<dynamic> Function(String)> asyncParams;
  final Widget Function(BuildContext, FFParameters) builder;
  final List<GoRoute> routes;

  GoRoute toRoute(AppStateNotifier appStateNotifier) => GoRoute(
        name: name,
        path: path,
        pageBuilder: (context, state) {
          fixStatusBarOniOS16AndBelow(context);
          final ffParams = FFParameters(state, asyncParams);
          final page = ffParams.hasFutures
              ? FutureBuilder(
                  future: ffParams.completeFutures(),
                  builder: (context, _) => builder(context, ffParams),
                )
              : builder(context, ffParams);
          final child = page;

          final transitionInfo = state.transitionInfo;
          return transitionInfo.hasTransition
              ? CustomTransitionPage(
                  key: state.pageKey,
                  name: state.name,
                  child: child,
                  transitionDuration: transitionInfo.duration,
                  transitionsBuilder:
                      (context, animation, secondaryAnimation, child) =>
                          PageTransition(
                    type: transitionInfo.transitionType,
                    duration: transitionInfo.duration,
                    reverseDuration: transitionInfo.duration,
                    alignment: transitionInfo.alignment,
                    child: child,
                  ).buildTransitions(
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ),
                )
              : MaterialPage(
                  key: state.pageKey, name: state.name, child: child);
        },
        routes: routes,
      );
}

class TransitionInfo {
  const TransitionInfo({
    required this.hasTransition,
    this.transitionType = PageTransitionType.fade,
    this.duration = const Duration(milliseconds: 300),
    this.alignment,
  });

  final bool hasTransition;
  final PageTransitionType transitionType;
  final Duration duration;
  final Alignment? alignment;

  static TransitionInfo appDefault() => TransitionInfo(hasTransition: false);
}

class RootPageContext {
  const RootPageContext(this.isRootPage, [this.errorRoute]);
  final bool isRootPage;
  final String? errorRoute;

  static bool isInactiveRootPage(BuildContext context) {
    final rootPageContext = context.read<RootPageContext?>();
    final isRootPage = rootPageContext?.isRootPage ?? false;
    final location = GoRouterState.of(context).uri.toString();
    return isRootPage &&
        location != '/' &&
        location != rootPageContext?.errorRoute;
  }

  static Widget wrap(Widget child, {String? errorRoute}) => Provider.value(
        value: RootPageContext(true, errorRoute),
        child: child,
      );
}

extension GoRouterLocationExtension on GoRouter {
  String getCurrentLocation() {
    final RouteMatch lastMatch = routerDelegate.currentConfiguration.last;
    final RouteMatchList matchList = lastMatch is ImperativeRouteMatch
        ? lastMatch.matches
        : routerDelegate.currentConfiguration;
    return matchList.uri.toString();
  }
}
