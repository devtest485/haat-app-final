import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:haat/custom_code/widgets/otp_verify.dart';

/// The six-box code field.
///
/// These assert callbacks and field contents, not layout, so they run on the host —
/// unlike the layout audit, which needs a device because the app fetches its font at
/// runtime.
///
/// The prefill is the development shortcut described in `docs/BEFORE-GOING-LIVE.md`.
/// What matters is the boundary of it: the digits go in, the parent is told, and
/// nothing is submitted on the user's behalf.
void main() {
  Future<void> pump(
    WidgetTester tester, {
    String? initialValue,
    void Function(String)? onChanged,
    void Function(bool)? onCompleted,
  }) =>
      tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OtpVerify(
              initialValue: initialValue,
              autoFocus: false,
              onChanged: onChanged == null
                  ? null
                  : (value) async => onChanged(value),
              onCompleted: onCompleted == null
                  ? null
                  : (complete) async => onCompleted(complete),
            ),
          ),
        ),
      );

  List<String> boxTexts(WidgetTester tester) => tester
      .widgetList<TextField>(find.byType(TextField))
      .map((field) => field.controller?.text ?? '')
      .toList();

  group('without an initial value', () {
    testWidgets('starts empty', (tester) async {
      await pump(tester);

      expect(find.byType(TextField), findsNWidgets(6));
      expect(boxTexts(tester).join(), isEmpty);
    });
  });

  group('with an initial value', () {
    testWidgets('fills every box', (tester) async {
      await pump(tester, initialValue: '482913');
      await tester.pump();

      expect(boxTexts(tester), ['4', '8', '2', '9', '1', '3']);
    });

    testWidgets('tells the parent, so its Continue button can enable',
        (tester) async {
      // Setting a controller's text does not fire the field's onChanged, so without
      // this the page would hold an empty code while the boxes showed a full one.
      final reported = <String>[];
      await pump(
        tester,
        initialValue: '482913',
        onChanged: reported.add,
      );
      await tester.pump();

      expect(reported, ['482913']);
    });

    testWidgets('does not submit on the user\'s behalf', (tester) async {
      // Submitting here would skip the screen entirely, and the screen is one of the
      // things worth testing. The user still taps Continue.
      var completed = false;
      await pump(
        tester,
        initialValue: '482913',
        onCompleted: (_) => completed = true,
      );
      await tester.pump();

      expect(completed, isFalse);
    });

    testWidgets('ignores a value of the wrong length', (tester) async {
      await pump(tester, initialValue: '4829');
      await tester.pump();

      expect(boxTexts(tester).join(), isEmpty);
    });

    testWidgets('ignores anything that is not digits', (tester) async {
      // A backend that sent something unexpected should leave the boxes alone rather
      // than putting letters in a numeric field.
      await pump(tester, initialValue: '48A913');
      await tester.pump();

      expect(boxTexts(tester).join(), isEmpty);
    });

    testWidgets('follows a resend to the new code', (tester) async {
      // A resend issues a new code. Without this the boxes keep the previous one,
      // which then fails verification with no visible reason.
      await pump(tester, initialValue: '111111');
      await tester.pump();
      expect(boxTexts(tester), ['1', '1', '1', '1', '1', '1']);

      await pump(tester, initialValue: '222222');
      await tester.pump();

      expect(boxTexts(tester), ['2', '2', '2', '2', '2', '2']);
    });
  });

  group('typing', () {
    testWidgets('reports each digit and completes on the sixth', (tester) async {
      final reported = <String>[];
      var completed = false;

      await pump(
        tester,
        onChanged: reported.add,
        onCompleted: (_) => completed = true,
      );

      final boxes = find.byType(TextField);
      for (var index = 0; index < 6; index += 1) {
        await tester.enterText(boxes.at(index), '${index + 1}');
        await tester.pump();
      }

      expect(reported.last, '123456');
      expect(completed, isTrue, reason: 'the sixth digit is the submit');
    });

    testWidgets('never lets a box hold more than one digit', (tester) async {
      // Autofill and paste both deliver several characters to one box. A
      // LengthLimitingTextInputFormatter on the field takes the first and drops the
      // rest, which is why the multi-character branch in _handleChange is defensive
      // rather than load-bearing — the assertion here is the invariant, not which
      // character wins.
      await pump(tester);

      await tester.enterText(find.byType(TextField).first, '79');
      await tester.pump();

      expect(boxTexts(tester).first.length, 1);
    });
  });
}
