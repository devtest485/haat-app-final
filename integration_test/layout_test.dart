import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haat/flutter_flow/nav/nav.dart';
import 'package:haat/index.dart';
import 'package:haat/main.dart' as app;
import 'package:integration_test/integration_test.dart';

/// Boots the real app on the handset and visits every route, reporting layout overflow.
///
/// Three things had to be right before the answers were worth anything.
///
/// **It runs on the device.** The app asks for its typeface with
/// `GoogleFonts.inter(...)` and bundles no font files, so a host `flutter test` has no
/// Inter to measure with and falls back to a face with different metrics — reporting
/// overflow in rows that are fine and missing it in rows that are not. The host version
/// of this file claimed 40 broken pages; on the device there were three.
///
/// **It drives the real app.** An earlier version pumped each page inside a
/// `MaterialApp` of its own and reported one page as "overflowed by 99471 pixels",
/// which is what an unbounded parent looks like rather than a layout bug. A page
/// wrapped in a different tree than production gets different constraints, so the
/// answer was about the harness. This navigates the app's own router.
///
/// **It boots the app once.** `app.main()` per test stacks a second app on the first,
/// and the router's navigator key is a GlobalKey — so every test after the first died
/// on "Duplicate GlobalKeys detected", and the keyboard pass silently found no fields
/// and reported everything clean. One boot, then every check as a step.
///
/// ```
/// flutter test integration_test/layout_test.dart -d <device-id>
/// ```
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  /// Routes to visit, with the arguments the ones that take them need.
  ///
  /// Written out rather than read from the router, so a route added without a layout
  /// check is a visible omission in this file.
  final routes = <String, Map<String, String>>{
    OnBoardingPageWidget.routeName: {},
    PhoneNumberPageWidget.routeName: {},
    OtpVerifyPageWidget.routeName: {'phoneNum': '+249911234567'},
    CreatePasswordPageWidget.routeName: {},
    SecurePageWidget.routeName: {},
    PassCodePageWidget.routeName: {},
    BiomatricPageWidget.routeName: {},
    VerifyPageWidget.routeName: {},
    IdCardScanPageWidget.routeName: {},
    FaceScanPageWidget.routeName: {},
    SelfiInfoWidget.routeName: {},
    BusinessInfoWidget.routeName: {},
    LikeBusPageWidget.routeName: {},
    BusinessCatageriousWidget.routeName: {},
    SetupBisinessLocationPageWidget.routeName: {},
    BusinessLocatePageWidget.routeName: {},
    UsernamePageWidget.routeName: {},
    CongratsPageWidget.routeName: {'userName': '@merchant'},
    DocunmentInfoWidget.routeName: {},
    UploadDocWidget.routeName: {},
    AddAmountPageWidget.routeName: {},
    TapPayOutWidget.routeName: {},
    QRpayOutPageWidget.routeName: {},
    LinkPayOutPageWidget.routeName: {},
    BottomBarPagesWidget.routeName: {},
    DeliveryLocationWidget.routeName: {},
    RequestSuccessWidget.routeName: {},
    AddEmployeesWidget.routeName: {},
    AddEmpoleyNameWidget.routeName: {},
    SelectBranchWidget.routeName: {},
    EmpoleyRoleWidget.routeName: {},
    ReviewDetailsWidget.routeName: {},
    CreatingProfileWidget.routeName: {},
    EmployeDetailsWidget.routeName: {},
    // The screens the September FlutterFlow export added. SignInPage went with it,
    // split into the three below: a chooser, and one screen per credential.
    AddFundWidget.routeName: {'fund': '1000'},
    BankOTPVerificationWidget.routeName: {},
    OtherBanksWidget.routeName: {},
    BankDetialsWidget.routeName: {},
    PaymentStatusWidget.routeName: {'paymentStatus': 'success'},
    TransfermethodWidget.routeName: {'transferMode': 'bank'},
    PaymentReviewWidget.routeName: {},
    OnBordingScreenWidget.routeName: {},
    LoginScreenWidget.routeName: {},
    PasswardLoginWidget.routeName: {},
    PassCodeLoginWidget.routeName: {},
  };

  testWidgets('every route lays out on this device', (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 2));

    final atRest = <String, List<String>>{};
    final withKeyboard = <String, List<String>>{};
    var pagesWithFields = 0;

    for (final route in routes.entries) {
      final problems = await _visit(tester, route.key, route.value);
      if (problems.isNotEmpty) atRest[route.key] = problems;

      // Then the same page with the keyboard up, which is where a full-height layout
      // runs out of room. The keyboard is raised by tapping a real field: faking
      // viewInsets on the test view does nothing, because the app was already built
      // against the real view and never sees the change.
      final fields = find.byType(EditableText);
      if (fields.evaluate().isEmpty) continue;

      pagesWithFields += 1;
      final typing = await _collect(() async {
        await tester.tap(fields.first, warnIfMissed: false);
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 600));
        await tester.pump(const Duration(milliseconds: 600));
      });

      if (typing.isNotEmpty) withKeyboard[route.key] = typing;
    }

    _report(atRest, routes.length, 'AT REST');
    _report(withKeyboard, pagesWithFields, 'WITH KEYBOARD');

    expect(
      {...atRest, ...withKeyboard},
      isEmpty,
      reason: 'see the LAYOUT lists above',
    );
  });
}

/// Navigates to [routeName] and returns every layout complaint it raised.
Future<List<String>> _visit(
  WidgetTester tester,
  String routeName,
  Map<String, String> queryParameters,
) =>
    _collect(() async {
      final context = appNavigatorKey.currentContext;
      if (context == null) throw StateError('no navigator — the app did not start');

      context.goNamed(routeName, queryParameters: queryParameters);

      // pumpAndSettle would hang on a page with a looping animation, and several of
      // these have one. Fixed pumps instead, and enough of them to sit on the page for
      // a moment: a layout that settles into overflowing does so after the post-frame
      // callbacks have run, not on the first frame.
      await tester.pump();
      for (var frame = 0; frame < 4; frame += 1) {
        await tester.pump(const Duration(milliseconds: 400));
      }
    });

/// Runs [action] with layout errors intercepted, and returns what it raised.
///
/// `tester.takeException` surfaces only the first. Layout errors arrive through
/// `FlutterError.onError`, so that is intercepted and all of them gathered — a page
/// usually has more than one, and fixing them one device run at a time is slow.
Future<List<String>> _collect(Future<void> Function() action) async {
  final problems = <String>{};
  final previous = FlutterError.onError;

  FlutterError.onError = (details) {
    final message = details.exceptionAsString();
    if (message.contains('overflowed') ||
        message.contains('RenderBox was not laid out') ||
        message.contains('unbounded')) {
      problems.add(_summarise(message));

      return;
    }

    // Anything else is not what this test is about, but dropping it is worse
    // than letting it through: the framework counts an error nobody dealt with
    // and ends the run with "a test overrode FlutterError.onError ... had
    // unexpected additional errors that it could not handle", which says
    // nothing about what actually went wrong. That assertion was the only
    // failure left once the three overflowing pages were fixed — the real error
    // had been hidden behind them the whole time. Forwarded so it is reported
    // as itself.
    previous?.call(details);
  };

  try {
    await action();
  } catch (error) {
    problems.add('threw: $error');
  } finally {
    FlutterError.onError = previous;
  }

  return problems.toList();
}

void _report(Map<String, List<String>> findings, int total, String label) {
  if (findings.isEmpty) {
    debugPrint('\nLAYOUT ($label): all $total pages lay out cleanly.\n');

    return;
  }

  debugPrint('\nLAYOUT ($label) — ${findings.length} of $total pages:');
  findings.forEach((route, problems) {
    debugPrint('  $route');
    for (final problem in problems) {
      debugPrint('      $problem');
    }
  });
  debugPrint('');
}

/// The first line of an overflow report — the part saying where, and by how much.
String _summarise(String message) {
  final line = message.split('\n').first.trim();

  return line.length > 150 ? '${line.substring(0, 150)}…' : line;
}
