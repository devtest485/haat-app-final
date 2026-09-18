import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haat/custom_code/api_result.dart';
import 'package:haat/custom_code/auth_session.dart';
import 'package:haat/flutter_flow/nav/nav.dart';
import 'package:haat/index.dart';
import 'package:haat/main.dart' as app;
import 'package:integration_test/integration_test.dart';

/// Boots the app, opens one page, and holds it on screen long enough to
/// photograph.
///
/// `IntegrationTestWidgetsFlutterBinding.takeScreenshot` needs a driver running
/// alongside the test, which `flutter test integration_test/...` does not give
/// you. So the picture is taken from the host instead, while this sits on the
/// page:
///
/// ```
/// flutter test integration_test/show_page.dart -d <device-id>
/// adb exec-out screencap -p > page.png      # from another shell, a few seconds in
/// ```
///
/// Change [_route] to look at a different screen. This is a viewing tool, not a
/// check — it asserts nothing and is not part of the suite's coverage.
const String _route = 'LikeBusPage';

/// How long the page stays up.
///
/// Generous because the marker below reaches the host's log late — device
/// `debugPrint` is flushed in batches — so a capture triggered by seeing it can
/// arrive well after the page went up. A minute is long enough that the timing
/// stops mattering.
const Duration _hold = Duration(seconds: 60);

/// Whether to sign in first.
///
/// The two business-setup screens read `GET /organizations/setup-options`, which needs
/// a bearer token — so without this they show the server's "this request needs a bearer
/// token" rather than the list, which is correct behaviour and not what you came to
/// look at.
const bool _signIn = true;

/// Registers a throwaway number and verifies it, leaving the app signed in.
///
/// Uses the real endpoints rather than writing a token into storage: the point is to
/// look at a screen in the state a merchant reaches it in, and a hand-made session is
/// not that state. Depends on the backend returning `devOtpCode`, which every
/// non-production environment does — against one that does not, this stops and says so.
Future<void> _register(WidgetTester tester) async {
  final session = AuthSession.instance;
  final mobile = '+2499000${DateTime.now().millisecondsSinceEpoch % 100000}';

  await tester.runAsync(() async {
    final started = await session.register(mobile: mobile);

    if (started is! ApiSuccess) {
      debugPrint('SIGN-IN FAILED at register: ${started.messageIn('en')}');

      return;
    }

    final code = session.devOtpCode;
    if (code == null || code.isEmpty) {
      debugPrint('SIGN-IN FAILED: the backend did not return devOtpCode.');

      return;
    }

    final verified = await session.verifyOtp(code: code, mobile: mobile);

    debugPrint(
      verified is ApiSuccess
          ? 'SIGNED IN as $mobile'
          : 'SIGN-IN FAILED at verify: ${verified.messageIn('en')}',
    );
  });

  await tester.pump(const Duration(milliseconds: 600));
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('holds $_route on screen', timeout: const Timeout(Duration(minutes: 3)),
      (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 2));

    if (_signIn) await _register(tester);

    appNavigatorKey.currentContext!.goNamed(_route);

    // Fixed pumps rather than pumpAndSettle: several of these pages run a
    // looping animation, and settling on one never returns.
    await tester.pump();
    for (var frame = 0; frame < 6; frame += 1) {
      await tester.pump(const Duration(milliseconds: 400));
    }

    debugPrint('SHOWING $_route — capture now.');

    // `runAsync` rather than a loop of `pump`: pump advances the test's own
    // clock, which costs no wall-clock time at all, so the page flashed past and
    // the run ended before any camera could see it. This waits in real seconds,
    // leaving the last painted frame up — which is exactly what gets captured.
    await tester.runAsync(() => Future<void>.delayed(_hold));
  });
}
