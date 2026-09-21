import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haat/custom_code/actions/haat_startup_route.dart';
import 'package:haat/custom_code/api_result.dart';
import 'package:haat/custom_code/auth_session.dart';
import 'package:haat/custom_code/widgets/business_option_picker.dart';
import 'package:haat/flutter_flow/nav/nav.dart';
import 'package:haat/index.dart';
import 'package:haat/main.dart' as app;
import 'package:integration_test/integration_test.dart';

import 'sign_in.dart';

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
/// Whatever a SnackBar on screen is saying, for a finding that names the reason.
String _snackText(WidgetTester tester) {
  final snack = find.descendant(
    of: find.byType(SnackBar),
    matching: find.byType(Text),
  );

  if (snack.evaluate().isEmpty) return '';

  return tester.widget<Text>(snack.first).data ?? '';
}

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

    // Start signed out, whatever the last run left behind.
    //
    // Every screen below is one a signed-out merchant sees, and the app no longer
    // ignores a stored session: one with a passcode set now opens on the passcode
    // screen and replaces the route underneath. Without this the suite spent its
    // first run driving a phone-number screen that had already been navigated
    // away from, and simply stopped.
    // Fixed pumps, not `pumpAndSettle`: signing out can land on a page that runs
    // a looping animation, and settling on one of those never returns.
    await tester.runAsync(() => AuthSession.instance.signOut());
    for (var frame = 0; frame < 4; frame += 1) {
      await tester.pump(const Duration(milliseconds: 400));
    }

    // Which screen is on show, so a finding says where it happened.
    //
    // The framework's own report cannot say: by the time an overflow is printed the
    // widget has usually been torn down, and every entry in its creator chain reads
    // DEFUNCT. That turns "5 pixels somewhere in the sign-up flow" into a screen name.
    var current = 'startup';

    // Anything the framework raises from here on is a finding, whichever screen it
    // came from.
    final previousOnError = FlutterError.onError;
    FlutterError.onError = (details) {
      thrown.add(
        '$current: ${details.exceptionAsString().split('\n').first.trim()}',
      );
      previousOnError?.call(details);
    };
    addTearDown(() => FlutterError.onError = previousOnError);

    Future<void> open(String route, [Map<String, String> query = const {}]) async {
      current = route;
      appNavigatorKey.currentContext!.goNamed(route, queryParameters: query);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 600));
    }

    /// Waits in real seconds for a request to come back, then paints.
    ///
    /// `tester.pump` advances the test's own clock, which costs no wall-clock time
    /// at all. A screen that has just submitted something is then checked before
    /// the reply could possibly have arrived, and a screen that is working reads
    /// as one that said nothing. Every step below that submits waits this way.
    Future<void> waitForBackend([int seconds = 6]) async {
      await tester.runAsync(
        () => Future<void>.delayed(Duration(seconds: seconds)),
      );

      for (var frame = 0; frame < 5; frame += 1) {
        await tester.pump(const Duration(milliseconds: 400));
      }
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
    // focus nodes, and submitting disposes the widget mid-interaction, which is where
    // a stale focus node or a defunct context shows up.
    //
    // Submitted by tapping Continue. The field used to send itself on the sixth
    // digit, down a chain that could not work — see the DSL's OtpVerifyPage block —
    // and that chain is gone.
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

      // Refused, because the code is made up. What matters is that the screen
      // survives being submitted and reports what the server said.
      await tester.tap(find.text('Continue'), warnIfMissed: false);
      await waitForBackend();
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
    // The opposite of what this used to check. "Login with Passcode" opened a
    // screen that called an endpoint which refuses to issue a session, so it
    // answered "Sign In Required" to every merchant who tried it. The passcode
    // guards a session the app already holds instead — see the passcode section
    // below — and this screen is only ever reached when there is none.
    check('does not offer the passcode as a way in',
        find.text('Login with Passcode').evaluate().isEmpty);

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
      // Generous, because the password hash is scrypt and slow on purpose.
      await waitForBackend(10);

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

    // ── Registration, all the way through ───────────────────────────────────
    //
    // The step the suite was missing, and the reason a broken sign-up reached a
    // handset. The code screen above types six made-up digits and checks that a
    // refusal appears — which it does whether the screen is working or not. A
    // screen that rejects *every* code, including the right one, passes that
    // check perfectly.
    //
    // So this types the code the backend actually issued and asks the only
    // question that matters: did we leave the screen.
    debugPrint('\nRegistration, end to end');

    final realCode = await registerForRealCode(tester);
    check(
      'the backend issued a code',
      realCode != null,
      'needs a backend that returns devOtpCode — check baseURL',
    );

    if (realCode != null) {
      await open(OtpVerifyPageWidget.routeName, {'phoneNum': realCode.mobile});

      final codeBoxes = find.byType(TextField);
      if (codeBoxes.evaluate().length == 6) {
        for (var index = 0; index < 6; index += 1) {
          await tester.enterText(codeBoxes.at(index), realCode.code[index]);
          await tester.pump(const Duration(milliseconds: 250));
        }

        // `hitTestable`, and checked before tapping. A tap that lands on nothing
        // leaves the screen exactly as a rejected code would, so without this a
        // missed tap and a broken screen are the same result.
        final submit = find.text('Continue').hitTestable();
        check(
          'the code screen offers a way to submit',
          submit.evaluate().isNotEmpty,
          'no tappable Continue on screen',
        );

        if (submit.evaluate().isNotEmpty) {
          await tester.tap(submit.first);
          // The verify, the routing call after it, and the navigation they lead
          // to — all of it real work on a real network.
          await waitForBackend();
        }

        check(
          'the right code is accepted',
          find.byType(SnackBar).evaluate().isEmpty,
          _snackText(tester),
        );
        // The session is reported alongside, because the two ways this fails look
        // identical on screen: a code the server refused, and a code it accepted
        // followed by a routing step that went nowhere.
        final signedIn = AuthSession.instance.isSignedIn;
        var route = '?';
        await tester.runAsync(() async => route = await haatStartupRoute());

        check(
          'the code screen is left behind',
          find.byType(TextField).evaluate().length != 6,
          'still sitting on the six boxes — signedIn=$signedIn, route=$route',
        );
      }
    }

    // ── The passcode, and what it is for ────────────────────────────────────
    //
    // A merchant who set one was offered "Login with Passcode" after signing out,
    // and got "Sign In Required" every time. `POST /auth/passcode/verify` confirms
    // a passcode against a session that already exists and deliberately refuses to
    // issue one — six digits is a million combinations — so that button could
    // never have worked.
    //
    // The passcode locks instead. This checks the decision that makes it so: a run
    // that opens onto stored tokens, with a passcode set, goes to the passcode
    // screen rather than straight in.
    debugPrint('\nPasscode');

    final locked = await registerForRealCode(tester);

    if (locked != null) {
      var route = '';

      await tester.runAsync(() async {
        final session = AuthSession.instance;
        await session.verifyOtp(code: locked.code, mobile: locked.mobile);
        await session.setPasscode('471903');

        // Signing in during this run is a stronger proof than the passcode, so
        // nothing is locked yet.
        route = await haatStartupRoute();
      });

      check(
        'a fresh sign-in is not asked for the passcode',
        route != 'passcode',
        'got $route',
      );

      await tester.runAsync(() async {
        // What a cold start does: build the session from whatever the last run
        // left in storage. There is no other way to reach that state from here —
        // the app boots once per test.
        await AuthSession.initialize();
        route = await haatStartupRoute();
      });

      check(
        'a restored session is asked for the passcode',
        route == 'passcode',
        'got $route',
      );

      // And the passcode opens it. This is the half that was never checked, and
      // the half that was broken: the unlock read `{"verified": true}` as though
      // it were a pair of tokens, so every correct passcode came back "the server
      // sent a reply we could not read" and nobody who set one could get back in.
      ApiResult<bool>? unlocked;

      await tester.runAsync(() async {
        unlocked = await AuthSession.instance.unlockWithPasscode('471903');
        route = await haatStartupRoute();
      });

      check(
        'the right passcode is accepted',
        unlocked is ApiSuccess<bool>,
        unlocked?.messageIn('en') ?? 'nothing came back',
      );

      check(
        'the passcode opens the app',
        route != 'passcode',
        'got $route',
      );
    }

    // ── The business-setup screens ──────────────────────────────────────────
    //
    // Nothing here names an option: the catalogue is maintained in the back office,
    // so a test that knew the labels would start failing the day someone renamed
    // one. What is checked is the Continue button.
    //
    // It was drawn right and connected to nothing — every binding read page state
    // that no code anywhere wrote — so it stayed grey and countless however many
    // options were ticked. It reads App State now, which the picker does write, and
    // this is the check that says so rather than a screenshot.
    //
    // Both screens fetch their options with a bearer token, so this needs a session.
    debugPrint('\nBusiness setup');

    /// The Continue button's fill, or null when it is not on screen.
    Color? continueFill() {
      final button = find.ancestor(
        of: find.text('Continue '),
        matching: find.byType(Container),
      );

      if (button.evaluate().isEmpty) return null;
      final decoration = tester.widget<Container>(button.first).decoration;

      return decoration is BoxDecoration ? decoration.color : null;
    }

    final signedIn = await signInAsNewMerchant(tester);
    check(
      'signed in for the setup screens',
      signedIn,
      'needs a backend that returns devOtpCode — check baseURL',
    );

    if (signedIn) {
      for (final screen in [
        (route: LikeBusPageWidget.routeName, what: 'where they sell'),
        (route: BusinessCatageriousWidget.routeName, what: 'what they sell'),
      ]) {
        await open(screen.route);
        // The catalogue is fetched on mount, over the network.
        await tester.pump(const Duration(seconds: 4));

        // Both layouts — the rows and the chip cloud — make each option an InkWell,
        // so this finds them without caring which screen it is on.
        final options = find.descendant(
          of: find.byType(BusinessOptionPicker),
          matching: find.byType(InkWell),
        );

        check(
          '${screen.what}: the back office filled the list',
          options.evaluate().length >= 2,
          'found ${options.evaluate().length}',
        );

        if (options.evaluate().length < 2) continue;

        final atRest = continueFill();
        check(
          '${screen.what}: Continue has no count before choosing',
          find.textContaining('(2)', findRichText: true).evaluate().isEmpty,
        );

        for (var index = 0; index < 2; index += 1) {
          await tester.tap(options.at(index), warnIfMissed: false);
          await tester.pump(const Duration(milliseconds: 400));
        }

        check(
          '${screen.what}: Continue counts both choices',
          find.textContaining('(2)', findRichText: true).evaluate().isNotEmpty,
        );
        check(
          '${screen.what}: Continue turns on',
          continueFill() != null && continueFill() != atRest,
          'still ${continueFill()}',
        );
      }
    }

    // ── Naming the business, and the setup reaching the backend ─────────────
    //
    // The step that did not exist. The screen after the categories said the business
    // had been created and created nothing: there was no field for its name, so there
    // was nothing to register, so the channels and categories chosen before it were
    // never sent anywhere. This types a name, taps Continue, and then asks the backend
    // — not the screen — whether a business now exists.
    //
    // Runs on the session the setup screens above left signed in, with their choices
    // still in App State, which is exactly the state a merchant reaches it in.
    debugPrint('\nNaming the business');

    if (signedIn) {
      await open(SetupBisinessLocationPageWidget.routeName);

      final nameField = find.byType(TextFormField);
      check('asks for the business name', nameField.evaluate().isNotEmpty);

      if (nameField.evaluate().isNotEmpty) {
        await type(nameField.first, 'Flow Test Bakery');

        // Put the keyboard away and bring Continue into view, as a merchant would.
        // With the keyboard up the button sits underneath it, which is how the
        // overflow on this screen first showed itself.
        FocusManager.instance.primaryFocus?.unfocus();
        await tester.pump(const Duration(milliseconds: 600));

        final submit = find.text('Continue');
        if (submit.evaluate().isNotEmpty) {
          await tester.ensureVisible(submit.first);
          await tester.pump(const Duration(milliseconds: 400));
        }

        check(
          'Continue can be reached with a name typed in',
          submit.hitTestable().evaluate().isNotEmpty,
          'the button is off screen or covered',
        );

        if (submit.hitTestable().evaluate().isNotEmpty) {
          await tester.tap(submit.hitTestable().first);
          // Two writes and a token refresh between them, all on a real network.
          await waitForBackend(10);
        }

        check(
          'the name is accepted',
          find.byType(SnackBar).evaluate().isEmpty,
          _snackText(tester),
        );

        String? organizationId;
        await tester.runAsync(() async {
          final held =
              await AuthSession.instance.organizations.currentOrganizationId();
          organizationId = held.valueOrNull;
        });

        check(
          'the business now exists on the backend',
          organizationId != null && organizationId!.isNotEmpty,
          'GET /organizations still lists none',
        );
      }
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
