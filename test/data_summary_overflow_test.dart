import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_bagus/data_summary_page.dart';

void main() {
  for (final size in [
    const Size(360, 800),
    const Size(393, 852),
    const Size(440, 956),
  ]) {
    testWidgets('no overflow at ${size.width.toInt()}x${size.height.toInt()}', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(size);
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(fontFamily: 'SF Pro Display'),
          home: const DataSummaryPage(),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('back button pops to previous page', (tester) async {
    await tester.binding.setSurfaceSize(const Size(440, 956));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeData(fontFamily: 'SF Pro Display'),
        home: Builder(
          builder: (context) => Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DataSummaryPage()),
                ),
                child: const Text('dashboard'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('dashboard'));
    await tester.pumpAndSettle();
    final back = find.byIcon(Icons.chevron_left_rounded);
    expect(back, findsOneWidget);
    final topLeft = tester.getTopLeft(back).dx;
    expect(
      topLeft,
      lessThan(40),
      reason: 'back button should be near the left screen edge',
    );
    await tester.tap(back);
    await tester.pumpAndSettle();
    expect(find.text('dashboard'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('division sidebar opens, selects division, and closes', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(440, 956));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(MaterialApp(home: const DataSummaryPage()));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('division-sidebar-toggle')));
    await tester.pumpAndSettle();
    expect(find.text('Divisi Apotek'), findsNWidgets(2));
    expect(find.text('Divisi Kebidanan'), findsOneWidget);
    expect(find.text('Divisi Pendaftaran'), findsOneWidget);
    expect(find.text('Divisi Rawat Inap'), findsOneWidget);
    expect(find.text('Divisi Rawat Jalan'), findsOneWidget);
    expect(find.text('Divisi UGD'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('division-Divisi UGD')));
    await tester.pumpAndSettle();
    expect(find.text('Divisi UGD'), findsOneWidget);
    expect(find.byKey(const ValueKey('division-Divisi UGD')), findsNothing);
    expect(find.text('Data Penggunaan Obat'), findsAtLeastNWidgets(1));
    expect(find.text('Data Penggunaan Obat Divisi UGD'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('division sidebar dismisses outside tap', (tester) async {
    await tester.binding.setSurfaceSize(const Size(440, 956));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(MaterialApp(home: const DataSummaryPage()));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('division-sidebar-toggle')));
    await tester.pumpAndSettle();
    expect(find.text('Divisi Kebidanan'), findsOneWidget);
    await tester.tapAt(const Offset(350, 500));
    await tester.pumpAndSettle();
    expect(find.text('Divisi Kebidanan'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'date popup opens, navigates months, and dismisses on outside tap',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(440, 956));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData(fontFamily: 'SF Pro Display'),
          home: const DataSummaryPage(),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.calendar_today_outlined), findsNothing);
      await tester.tap(find.text('2026,12'));
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.calendar_today_outlined), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('date-popup-prev')));
      await tester.pumpAndSettle();
      expect(find.text('2026,11'), findsNWidgets(2));
      await tester.tap(find.byKey(const ValueKey('date-popup-next')));
      await tester.pumpAndSettle();
      expect(find.text('2026,12'), findsNWidgets(2));
      await tester.tap(
        find.byIcon(Icons.chevron_right_rounded).first,
        warnIfMissed: false,
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(Icons.calendar_today_outlined), findsNothing);
    },
  );
}
