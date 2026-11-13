import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_bagus/laporan_saya_page.dart';

void main() {
  for (final size in [const Size(440, 956), const Size(360, 800)]) {
    testWidgets(
      'laporan saya has aligned header and search at ${size.width.toInt()}x${size.height.toInt()}',
      (tester) async {
        await tester.binding.setSurfaceSize(size);
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.pumpWidget(const MaterialApp(home: LaporanSayaPage()));
        await tester.pumpAndSettle();

        expect(find.text('Laporan Saya'), findsOneWidget);
        expect(find.text('Cari'), findsOneWidget);
        expect(find.text('Filter'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'laporan saya filter popup shows only Ditolak and Ditandai and filters cards',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(440, 956));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(const MaterialApp(home: LaporanSayaPage()));
      await tester.pumpAndSettle();

      // Initially both accepted (check) and rejected (close) badges are shown.
      expect(find.byIcon(Icons.check_rounded), findsWidgets);
      expect(find.byIcon(Icons.close_rounded), findsWidgets);

      // Open filter popup.
      await tester.tap(find.byKey(const ValueKey('laporan-saya-filter-button')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('laporan-saya-filter-popup')),
        findsOneWidget,
      );
      expect(find.text('Ditolak'), findsOneWidget);
      expect(find.text('Ditandai'), findsOneWidget);
      expect(find.text('Belum Ditandai'), findsNothing);
      expect(find.text('2026,12'), findsOneWidget);
      expect(find.text('Terapkan'), findsOneWidget);

      // Unselect 'Ditolak' and apply filter so only 'Ditandai' cards remain.
      await tester.tap(find.text('Ditolak'));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('laporan-saya-filter-apply')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('laporan-saya-filter-popup')),
        findsNothing,
      );
      expect(find.byIcon(Icons.check_rounded), findsWidgets);
      expect(find.byIcon(Icons.close_rounded), findsNothing);
      expect(tester.takeException(), isNull);
    },
  );
}
