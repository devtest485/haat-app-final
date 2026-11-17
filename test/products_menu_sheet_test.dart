import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:haat/components/products_menu_sheet/products_menu_sheet_widget.dart';
import 'package:haat/flutter_flow/flutter_flow_theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:haat/flutter_flow/flutter_flow_util.dart';

void main() {
  testWidgets('products menu sheet follows the Figma sizes and returns its result',
      (tester) async {
    GoogleFonts.config.allowRuntimeFetching = false;
    SharedPreferences.setMockInitialValues({});
    await FlutterFlowTheme.initialize();
    final appState = FFAppState();
    await appState.initializePersistedState();
    tester.view.physicalSize = const Size(375 * 3, 700 * 3);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    FlutterError.onError = (_) {};

    String? result;
    await tester.pumpWidget(ChangeNotifierProvider(
      create: (_) => appState,
      child: MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.bottomCenter,
            child: Builder(
              builder: (context) => TextButton(
                onPressed: () async => result = await showModalBottomSheet<String>(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (_) => const ProductsMenuSheetWidget(),
                ),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle(const Duration(seconds: 2));

    final sheet = tester.getRect(find.byType(ProductsMenuSheetWidget));
    final rows = tester
        .widgetList<Container>(find.byWidgetPredicate((w) =>
            w is Container &&
            w.decoration is BoxDecoration &&
            (w.decoration as BoxDecoration).color == const Color(0xFFFAFAFA)))
        .map((c) => tester.getRect(find.byWidget(c)))
        .toList();
    expect(rows.length, 2);
    // ignore: avoid_print
    print('sheet=$sheet rows=$rows');
    expect(sheet.width, 375);
    expect(sheet.height, 283);
    for (final r in rows) {
      expect(r.height, 66);
      expect(r.left, 10);
      expect(r.right, 365);
    }
    expect(rows[1].top - rows[0].bottom, 4);

    await tester.tap(find.text('Manage products'));
    await tester.pumpAndSettle();
    expect(result, 'manage');
  });
}
