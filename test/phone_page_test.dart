import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haat/auth_flow/phone_number_page/phone_number_page_widget.dart';
import 'package:haat/flutter_flow/flutter_flow_theme.dart';
import 'package:haat/flutter_flow/flutter_flow_util.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

double opacityOf(WidgetTester tester, String text) {
  var total = 1.0;
  final element = tester.element(find.text(text));
  element.visitAncestorElements((e) {
    final w = e.widget;
    if (w is Opacity) total *= w.opacity;
    if (w is FadeTransition) total *= w.opacity.value;
    return true;
  });
  return total;
}

void main() {
  testWidgets('phone page text rises in and the button lines up with the form',
      (tester) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({});
    await FlutterFlowTheme.initialize();
    final appState = FFAppState();
    await appState.initializePersistedState();
    tester.view.physicalSize = const Size(390 * 3, 844 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    // Missing bundled fonts are logged by google_fonts, not fatal.
    FlutterError.onError = (_) {};

    await tester.pumpWidget(ChangeNotifierProvider(
      create: (_) => appState,
      child: const MaterialApp(home: PhoneNumberPageWidget()),
    ));

    const title = "Let's get started!";
    await tester.pump(const Duration(milliseconds: 10));
    final start = opacityOf(tester, title);
    await tester.pump(const Duration(milliseconds: 300));
    final mid = opacityOf(tester, title);
    await tester.pump(const Duration(milliseconds: 1200));
    final end = opacityOf(tester, title);
    // ignore: avoid_print
    print('title opacity: start=$start mid=$mid end=$end');
    expect(start, lessThan(0.1));
    expect(mid, inInclusiveRange(0.1, 0.99));
    expect(end, 1.0);

    final field = tester.getRect(find.byType(Form));
    final button = tester.getRect(find.text('Continue'));
    final continueBox = tester.getRect(find
        .ancestor(of: find.text('Continue'), matching: find.byType(Container))
        .first);
    // ignore: avoid_print
    print('form right=${field.right} button box left=${continueBox.left} right=${continueBox.right} width=${tester.view.physicalSize.width / 3}');
    expect(button.center.dx, closeTo(195, 1));
    expect(continueBox.left, 15.0);
    expect(continueBox.right, 390.0 - 15.0);
    await tester.pumpAndSettle(const Duration(seconds: 2));
  });
}
