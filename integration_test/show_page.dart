import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haat/flutter_flow/nav/nav.dart';
import 'package:haat/main.dart' as app;
import 'package:integration_test/integration_test.dart';

import 'sign_in.dart';

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
const String _route = 'BottomBarPages';

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

/// Options to tap once the page is up, by their visible label. Empty to leave the
/// screen as it opens.
const List<String> _tap = [];

/// How long the untouched page stays up before [_tap] runs.
///
/// Two states worth photographing, one run: a screen whose button is only right
/// when something is chosen is also a screen whose button has to be right when
/// nothing is. Zero to go straight to the taps.
const Duration _restHold = Duration(seconds: 3);

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('holds $_route on screen', timeout: const Timeout(Duration(minutes: 3)),
      (tester) async {
    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 2));

    if (_signIn) await signInAsNewMerchant(tester);

    appNavigatorKey.currentContext!.goNamed(_route);

    // Fixed pumps rather than pumpAndSettle: several of these pages run a
    // looping animation, and settling on one never returns.
    await tester.pump();
    for (var frame = 0; frame < 6; frame += 1) {
      await tester.pump(const Duration(milliseconds: 400));
    }

    if (_tap.isNotEmpty && _restHold > Duration.zero) {
      debugPrint('SHOWING $_route untouched — capture now.');
      await tester.runAsync(() => Future<void>.delayed(_restHold));
    }

    // Tap a few options before the hold, so the picture shows the chosen state
    // as well as the resting one.
    //
    // Done through the tester rather than `adb shell input tap`: the live test
    // binding does not deliver injected touches the way a running app does, so
    // taps sent from the host land nowhere and the screen stays untouched.
    for (final label in _tap) {
      final target = find.text(label);
      if (target.evaluate().isEmpty) {
        debugPrint('NOT FOUND: $label');
        continue;
      }

      await tester.tap(target, warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 400));
      debugPrint('TAPPED: $label');
    }

    debugPrint('SHOWING $_route — capture now.');

    // `runAsync` rather than a loop of `pump`: pump advances the test's own
    // clock, which costs no wall-clock time at all, so the page flashed past and
    // the run ended before any camera could see it. This waits in real seconds,
    // leaving the last painted frame up — which is exactly what gets captured.
    await tester.runAsync(() => Future<void>.delayed(_hold));
  });
}
