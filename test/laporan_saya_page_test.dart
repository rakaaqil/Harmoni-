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
}
