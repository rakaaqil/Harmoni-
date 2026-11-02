import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_bagus/laporan_divisi_page.dart';

void main() {
  for (final size in [const Size(440, 956), const Size(360, 800)]) {
    testWidgets(
      'laporan divisi has no overflow at ${size.width.toInt()}x${size.height.toInt()}',
      (tester) async {
        await tester.binding.setSurfaceSize(size);
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.pumpWidget(const MaterialApp(home: LaporanDivisiPage()));
        await tester.pumpAndSettle();

        expect(find.text('Laporan Divisi'), findsOneWidget);
        expect(find.text('Laporan Divisi Apotek'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('search filters report rows', (tester) async {
    await tester.binding.setSurfaceSize(const Size(440, 956));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MaterialApp(home: LaporanDivisiPage()));
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const ValueKey('laporan-search-field')),
      'Ditolak',
    );
    await tester.pump();

    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Laporan xxx.xxx'), findsNWidgets(5));
    expect(find.text('Ditandai'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('filter popup opens, status applies, and closes', (tester) async {
    await tester.binding.setSurfaceSize(const Size(440, 956));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(const MaterialApp(home: LaporanDivisiPage()));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('laporan-filter-button')));
    await tester.pumpAndSettle();
    expect(find.byKey(const ValueKey('laporan-filter-popup')), findsOneWidget);
    expect(find.text('2026,12'), findsOneWidget);

    await tester.tap(find.text('Ditolak').last);
    await tester.tap(find.byKey(const ValueKey('laporan-filter-apply')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('laporan-filter-popup')), findsNothing);
    expect(find.text('Laporan xxx.xxx'), findsNWidgets(9));
    expect(find.text('Ditandai'), findsNWidgets(5));
    expect(tester.takeException(), isNull);
  });
}
