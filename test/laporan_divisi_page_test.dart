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

  for (final role in [
    (label: 'Staff', isReviewer: false, isKepalaRs: false),
    (label: 'Kepala Divisi', isReviewer: true, isKepalaRs: false),
    (label: 'Kepala Rumah Sakit', isReviewer: true, isKepalaRs: true),
  ]) {
    testWidgets(
      'division button (>) opens 6-division sidebar and updates rows for ${role.label}',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(440, 956));
        addTearDown(() => tester.binding.setSurfaceSize(null));

        await tester.pumpWidget(
          MaterialApp(
            home: LaporanDivisiPage(
              isReviewer: role.isReviewer,
              isKepalaRs: role.isKepalaRs,
            ),
          ),
        );
        await tester.pumpAndSettle();

        expect(find.text('Laporan Divisi Apotek'), findsOneWidget);
        expect(find.text('Laporan xxx.xxx'), findsNWidgets(14));

        // Tap '>' button to open 6-division sidebar
        await tester.tap(find.byKey(const ValueKey('laporan-division-button')));
        await tester.pumpAndSettle();

        for (final div in const [
          'Divisi Apotek',
          'Divisi Kebidanan',
          'Divisi Pendaftaran',
          'Divisi Rawat Inap',
          'Divisi Rawat Jalan',
          'Divisi UGD',
        ]) {
          expect(
            find.byKey(ValueKey('laporan-division-$div')),
            findsOneWidget,
          );
        }

        // Select Divisi UGD
        await tester.tap(
          find.byKey(const ValueKey('laporan-division-Divisi UGD')),
        );
        await tester.pumpAndSettle();

        expect(find.text('Laporan Divisi UGD'), findsOneWidget);
        expect(find.text('Laporan UGD 01'), findsOneWidget);
        expect(find.text('Rizky Ramadhan'), findsWidgets);

        // Select Divisi Kebidanan
        await tester.tap(find.byKey(const ValueKey('laporan-division-button')));
        await tester.pumpAndSettle();
        await tester.tap(
          find.byKey(const ValueKey('laporan-division-Divisi Kebidanan')),
        );
        await tester.pumpAndSettle();

        expect(find.text('Laporan Divisi Kebidanan'), findsOneWidget);
        expect(find.text('Laporan Kebidanan 01'), findsOneWidget);
        expect(find.text('Siti Aminah'), findsWidgets);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
