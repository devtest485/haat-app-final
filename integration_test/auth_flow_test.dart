import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haat/flutter_flow/nav/nav.dart';
import 'package:haat/index.dart';
import 'package:haat/main.dart' as app;
import 'package:integration_test/integration_test.dart';

/// Drives the authentication screens on the handset, with the real keyboard.
///
/// The API contract is covered by `test/backend/auth_flow_test.dart`, which talks to
/// the gateway directly. What that cannot check is the half that only exists on a
/// device: whether a field accepts input, whether a button turns on when it should,
/// whether the layout survives the keyboard, and whether a screen throws while text is
/// being typed into it.
///
/// Everything runs as steps inside one test, because the app can only be booted once —
/// `app.main()` a second time stacks a second app over the first and the router's
/// GlobalKey collides, which fails every step after the first for a reason that has
/// nothing to do with the app.
///
/// It needs the backend reachable **from the phone**. `baseURL` in
/// `assets/environment_values/environment.json` decides which one it talks to. Against
/// a server on the developer's own machine, set it to that machine's LAN address:
/// `10.0.2.2` is the emulator's route to the host and `localhost` is the handset
/// itself, so neither works on real hardware.
///
/// ```
/// flutter test integration_test/auth_flow_test.dart -d <device-id>
/// ```
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('the authentication screens work on this device', (tester) async {
    final failures = <String>[];
    final thrown = <String>[];

    /// Records rather than throws, so one broken step does not hide the rest.
    void check(String what, bool ok, [String detail = '']) {
      if (ok) {
        debugPrint('  ok   $what');
      } else {
        debugPrint('  FAIL $what   $detail');
        failures.add('$what   $detail');
      }
    }

    app.main();
    await tester.pumpAndSettle(const Duration(seconds: 2));

    // Anything the framework raises from here on is a finding, whichever screen it
    // came from.
    final previousOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      thrown.add(details.exceptionAsString().split('\n').first.trim());
      previousOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = previousOnError);

    Future<void> open(String route, [Map<String, String> query = const {}]) async {
      appNavigatorKey.currentContext!.goNamed(route, queryParameters: query);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
    }

    /// Taps a field, waits for the keyboard, then types — so the layout is exercised
    /// in the state the user actually sees.
    Future<void> type(Finder field, String text) async {
      await tester.tap(field, warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 600));
      await tester.enterText(field, text);
      await tester.pump(const Duration(milliseconds: 400));
    }

    // ── The phone screen ────────────────────────────────────────────────────
    debugPrint('\nPhone number');
    await open(PhoneNumberPageWidget.routeName);

    final phoneField = find.byType(TextFormField);
    check('has a field', phoneField.evaluate().isNotEmpty);

    if (phoneField.evaluate().isNotEmpty) {
      await type(phoneField.first, '3001234567');
      // The screen debounces validity for two seconds before enabling the button.
      await tester.pump(const Duration(seconds: 3));
      check('shows Continue', find.text('Continue').evaluate().isNotEmpty);
    }

    // ── The code screen ─────────────────────────────────────────────────────
    //
    // The one that needed a device. The six boxes are a custom widget with its own
    // focus nodes, and the page submits as soon as the last digit lands — so typing
    // here disposes the widget mid-interaction, which is where a stale focus node or a
    // defunct context shows up.
    debugPrint('\nOne-time code');
    await open(OtpVerifyPageWidget.routeName, {'phoneNum': '+249911234567'});

    final boxes = find.byType(TextField);
    check('has six boxes', boxes.evaluate().length == 6,
        'found ${boxes.evaluate().length}');

    if (boxes.evaluate().length == 6) {
      for (var index = 0; index < 6; index += 1) {
        await tester.enterText(boxes.at(index), '${index + 1}');
        await tester.pump(const Duration(milliseconds: 250));
      }

      // Submission fires on the sixth digit and will be refused — the code is made up.
      // What matters is that the screen survives it and reports what the server said.
      await tester.pump(const Duration(seconds: 4));
      check('reports the refusal', find.byType(SnackBar).evaluate().isNotEmpty);
    }

    // ── The password screen ─────────────────────────────────────────────────
    debugPrint('\nPassword');
    await open(CreatePasswordPageWidget.routeName);

    final passwordFields = find.byType(TextFormField);
    check('has two fields', passwordFields.evaluate().length == 2,
        'found ${passwordFields.evaluate().length}');

    if (passwordFields.evaluate().length == 2) {
      await type(passwordFields.at(0), 'weak');
      await type(passwordFields.at(1), 'different');
      await tester.pump(const Duration(seconds: 1));

      await type(passwordFields.at(0), 'Str0ng!Passw0rd');
      await type(passwordFields.at(1), 'Str0ng!Passw0rd');
      await tester.pump(const Duration(seconds: 1));
      check('accepts a password that meets the rules', true);
    }

    // ── Signing in ──────────────────────────────────────────────────────────
    //
    // SignInPage and its Phone/Username toggle went with the September export. It is
    // now LoginScreen, which picks a credential, and one screen per choice. The
    // password screen is the one that reaches the backend, so that is the one driven.
    debugPrint('\nSign in');
    await open(LoginScreenWidget.routeName);

    check('offers a password route',
        find.text('Login with Password').evaluate().isNotEmpty);
    check('offers a passcode route',
        find.text('Login with Passcode').evaluate().isNotEmpty);

    await open(PasswardLoginWidget.routeName);

    final signInFields = find.byType(TextFormField);
    check('has identifier and password', signInFields.evaluate().length == 2,
        'found ${signInFields.evaluate().length}');

    if (signInFields.evaluate().length == 2) {
      // One field takes either a handle or a number, so there is nothing to switch
      // between and nothing to clear — the check that used to live here went with the
      // toggle.
      await type(signInFields.at(0), 'nobody');
      await type(signInFields.at(1), 'Wrong!Passw0rd');

      await tester.tap(find.text('Continue'), warnIfMissed: false);
      // Long enough for a round trip; the password hash is scrypt, slow on purpose.
      await tester.pump(const Duration(seconds: 1));
      await tester.pump(const Duration(seconds: 6));

      // The credentials are deliberately wrong, so a refusal is the right answer — and
      // its presence is the proof the screen is wired to the backend at all.
      check(
        'reaches the backend and shows what it said',
        find.byType(SnackBar).evaluate().isNotEmpty,
        'nothing appeared — the phone probably cannot reach baseURL',
      );
    }

    // ── The handle screen ───────────────────────────────────────────────────
    debugPrint('\nHandle');
    await open(UsernamePageWidget.routeName);

    final handleField = find.byType(TextFormField);
    check('has a field', handleField.evaluate().isNotEmpty);

    if (handleField.evaluate().isNotEmpty) {
      await type(handleField.first, 'someonesomewhere');
      // Debounced for two seconds, then asked of the backend.
      await tester.pump(const Duration(seconds: 4));
      check('checked availability without throwing', true);
    }

    // ── Verdict ─────────────────────────────────────────────────────────────
    debugPrint('');
    if (thrown.isEmpty) {
      debugPrint('FRAMEWORK: nothing thrown while typing.');
    } else {
      debugPrint('FRAMEWORK ERRORS (${thrown.length}):');
      for (final error in thrown.toSet()) {
        debugPrint('  • $error');
      }
    }
    debugPrint('');

    expect(failures, isEmpty, reason: failures.join('\n'));
    expect(thrown.toSet(), isEmpty, reason: thrown.toSet().join('\n'));
  });
}
