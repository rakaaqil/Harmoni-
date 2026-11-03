import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_bagus/data/report_store.dart';
import 'package:app_bagus/data_summary_page.dart';
import 'package:app_bagus/kepala_divisi_dashboard_page.dart';
import 'package:app_bagus/kepala_rs_dashboard_page.dart';
import 'package:app_bagus/laporan_detail_page.dart';
import 'package:app_bagus/laporan_divisi_page.dart';
import 'package:app_bagus/models/user_profile.dart';
import 'package:app_bagus/tinjau_laporan_page.dart';
import 'package:app_bagus/widgets/chart_card.dart';
import 'package:app_bagus/widgets/report_card.dart';

Widget _app(Widget home) =>
    MaterialApp(theme: ThemeData(fontFamily: 'SF Pro Display'), home: home);

Future<void> _size(WidgetTester tester, [Size s = const Size(440, 956)]) async {
  await tester.binding.setSurfaceSize(s);
  addTearDown(() => tester.binding.setSurfaceSize(null));
}

final _tinjau = find.byKey(const ValueKey('tinjau-laporan-masuk'));

void main() {
  setUp(() {
    ReportStore.instance.reset();
  });

  testWidgets('reviewer bar vs staff bar', (tester) async {
    await _size(tester);
    await tester.pumpWidget(_app(const LaporanDivisiPage(isReviewer: true)));
    expect(find.text('Tinjau Laporan Masuk'), findsOneWidget);
    expect(find.text('Input Laporan'), findsNothing);
    expect(find.text('Laporan Saya'), findsNothing);

    await tester.pumpWidget(_app(const LaporanDivisiPage()));
    expect(find.text('Tinjau Laporan Masuk'), findsNothing);
    expect(find.text('Input Laporan'), findsOneWidget);
    expect(find.text('Laporan Saya'), findsOneWidget);
  });

  testWidgets(
    'reviewer accepts and rejects rows with reason dialog and syncs across TinjauLaporanPage and LaporanDivisiPage',
    (tester) async {
      await _size(tester);
      await tester.pumpWidget(_app(const LaporanDivisiPage(isReviewer: true)));

      // Accept row 3 ('Belum Ditandai' -> 'Ditandai')
      await tester.tap(find.byKey(const ValueKey('laporan-row-3')));
      await tester.pumpAndSettle();
      expect(find.byType(LaporanDetailPage), findsOneWidget);
      expect(find.byKey(const ValueKey('laporan-terima')), findsOneWidget);
      expect(find.byKey(const ValueKey('laporan-tolak')), findsOneWidget);
      expect(find.byKey(const ValueKey('laporan-download')), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('laporan-terima')));
      await tester.pumpAndSettle();
      expect(find.byType(LaporanDetailPage), findsNothing);
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('laporan-row-3')),
          matching: find.text('Ditandai'),
        ),
        findsOneWidget,
      );

      // Reject row 8 via dialog ('Belum Ditandai' -> 'Ditolak')
      await tester.tap(find.byKey(const ValueKey('laporan-row-8')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('laporan-tolak')));
      await tester.pumpAndSettle();
      expect(find.text('Alasan Penolakan'), findsOneWidget);
      await tester.enterText(
        find.byKey(const ValueKey('alasan-penolakan-field')),
        'Data kurang lengkap',
      );
      await tester.tap(find.byKey(const ValueKey('tolak-kirim')));
      await tester.pumpAndSettle();
      expect(find.byType(LaporanDetailPage), findsNothing);
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('laporan-row-8')),
          matching: find.text('Ditolak'),
        ),
        findsOneWidget,
      );
      expect(ReportStore.instance.reasonFor('8'), 'Data kurang lengkap');

      // Open TinjauLaporanPage via Tinjau Laporan Masuk button and verify row 3 & 8 are synced
      await tester.tap(_tinjau);
      await tester.pumpAndSettle();
      expect(find.byType(TinjauLaporanPage), findsOneWidget);
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('tinjau-row-3')),
          matching: find.text('Ditandai'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('tinjau-row-8')),
          matching: find.text('Ditolak'),
        ),
        findsOneWidget,
      );

      // Now reject row 1 from TinjauLaporanPage and verify it updates LaporanDivisiPage too
      await tester.tap(find.byKey(const ValueKey('tinjau-row-1')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('laporan-tolak')));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.byKey(const ValueKey('alasan-penolakan-field')),
        'Format salah',
      );
      await tester.tap(find.byKey(const ValueKey('tolak-kirim')));
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('tinjau-row-1')),
          matching: find.text('Ditolak'),
        ),
        findsOneWidget,
      );

      // Pop back to LaporanDivisiPage and check row 1 is also Ditolak
      await tester.tap(find.byIcon(Icons.chevron_left_rounded).first);
      await tester.pumpAndSettle();
      expect(find.byType(LaporanDivisiPage), findsOneWidget);
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('laporan-row-1')),
          matching: find.text('Ditolak'),
        ),
        findsOneWidget,
      );
    },
  );

  testWidgets('download shows snackbar', (tester) async {
    await _size(tester);
    await tester.pumpWidget(_app(const LaporanDivisiPage(isReviewer: true)));
    await tester.tap(find.byKey(const ValueKey('laporan-row-1')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('laporan-download')));
    await tester.pump();
    expect(find.text('Mengunduh Laporan xxx.xxx...'), findsOneWidget);
    expect(find.byType(LaporanDetailPage), findsOneWidget);
  });

  testWidgets('non-reviewer detail has no review actions', (tester) async {
    await _size(tester);
    await tester.pumpWidget(_app(const LaporanDivisiPage()));
    await tester.tap(find.byKey(const ValueKey('laporan-row-1')));
    await tester.pumpAndSettle();
    expect(find.byType(LaporanDetailPage), findsOneWidget);
    expect(find.byKey(const ValueKey('laporan-terima')), findsNothing);
    expect(find.byKey(const ValueKey('laporan-tolak')), findsNothing);
    expect(find.byKey(const ValueKey('laporan-download')), findsNothing);
    await tester.tap(find.byKey(const ValueKey('laporan-detail-back')));
    await tester.pumpAndSettle();
    expect(find.byType(LaporanDetailPage), findsNothing);
  });

  testWidgets('Tinjau Laporan Masuk opens TinjauLaporanPage', (tester) async {
    await _size(tester);
    await tester.pumpWidget(_app(const LaporanDivisiPage(isReviewer: true)));
    await tester.tap(_tinjau);
    await tester.pumpAndSettle();
    expect(find.byType(TinjauLaporanPage), findsOneWidget);
    expect(find.text('Tinjau Laporan'), findsOneWidget);
  });

  testWidgets('DataSummaryPage reviewer bar opens TinjauLaporanPage', (
    tester,
  ) async {
    await _size(tester);
    await tester.pumpWidget(_app(const DataSummaryPage()));
    await tester.pumpAndSettle();
    expect(find.text('Tinjau Laporan Masuk'), findsNothing);

    await tester.pumpWidget(_app(const DataSummaryPage(isReviewer: true)));
    await tester.pumpAndSettle();
    expect(find.text('Tinjau Laporan Masuk'), findsOneWidget);
    await tester.tap(find.text('Tinjau Laporan Masuk'));
    await tester.pumpAndSettle();
    expect(find.byType(TinjauLaporanPage), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('kepala divisi dashboard flows', (tester) async {
    await _size(tester);
    const home = KepalaDivisiDashboardPage(
      profile: UserProfile(
        name: 'Budi',
        email: 'b@x.id',
        role: 'kepala_divisi',
        division: 'Apotek',
      ),
    );
    await tester.pumpWidget(_app(home));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ChartCard));
    await tester.pumpAndSettle();
    expect(find.byType(DataSummaryPage), findsOneWidget);
    expect(find.text('Tinjau Laporan Masuk'), findsOneWidget);
    expect(find.text('Input Laporan'), findsNothing);
    await tester.tap(
      find.byType(BackButton).evaluate().isNotEmpty
          ? find.byType(BackButton)
          : find.byIcon(Icons.chevron_left_rounded).first,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ReportCard));
    await tester.pumpAndSettle();
    expect(find.byType(LaporanDivisiPage), findsOneWidget);
    expect(find.text('Tinjau Laporan Masuk'), findsOneWidget);
    expect(find.text('Input Laporan'), findsNothing);
  });

  testWidgets(
    'pencil button toggles multi-select mode in TinjauLaporanPage and bulk accept/reject works',
    (tester) async {
      await _size(tester);
      await tester.pumpWidget(_app(const TinjauLaporanPage()));
      await tester.pumpAndSettle();

      // Enter selection mode via pencil button
      expect(find.byKey(const ValueKey('tinjau-bulk-accept')), findsNothing);
      await tester.tap(find.byKey(const ValueKey('tinjau-edit-button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('tinjau-select-all')), findsOneWidget);
      expect(find.byKey(const ValueKey('tinjau-bulk-accept')), findsOneWidget);
      expect(find.byKey(const ValueKey('tinjau-bulk-reject')), findsOneWidget);
      expect(
        find.byKey(const ValueKey('tinjau-bulk-download')),
        findsOneWidget,
      );

      // Select rows 1 and 2 and bulk accept
      await tester.tap(find.byKey(const ValueKey('tinjau-row-1')));
      await tester.tap(find.byKey(const ValueKey('tinjau-row-2')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('tinjau-bulk-accept')));
      await tester.pumpAndSettle();

      // Selection mode closed and rows 1 & 2 are Ditandai
      expect(find.byKey(const ValueKey('tinjau-bulk-accept')), findsNothing);
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('tinjau-row-1')),
          matching: find.text('Ditandai'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('tinjau-row-2')),
          matching: find.text('Ditandai'),
        ),
        findsOneWidget,
      );

      // Enter selection mode again, select row 3, bulk reject with reason
      await tester.tap(find.byKey(const ValueKey('tinjau-edit-button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('tinjau-check-3')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('tinjau-bulk-reject')));
      await tester.pumpAndSettle();

      expect(find.text('Alasan Penolakan'), findsOneWidget);
      await tester.enterText(
        find.byKey(const ValueKey('alasan-penolakan-field')),
        'Revisi tabel',
      );
      await tester.tap(find.byKey(const ValueKey('tolak-kirim')));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('tinjau-bulk-reject')), findsNothing);
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('tinjau-row-3')),
          matching: find.text('Ditolak'),
        ),
        findsOneWidget,
      );
      expect(ReportStore.instance.reasonFor('3'), 'Revisi tabel');
    },
  );

  testWidgets(
    'division button (>) on LaporanDivisiPage opens sidebar and updates title',
    (tester) async {
      await _size(tester);
      await tester.pumpWidget(_app(const LaporanDivisiPage()));
      await tester.pumpAndSettle();

      expect(find.text('Laporan Divisi Apotek'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('laporan-division-button')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('laporan-division-Divisi UGD')),
        findsOneWidget,
      );
      await tester.tap(
        find.byKey(const ValueKey('laporan-division-Divisi UGD')),
      );
      await tester.pumpAndSettle();

      expect(find.text('Laporan Divisi UGD'), findsOneWidget);
    },
  );

  testWidgets(
    'Belum Diperiksa and Sudah Diperiksa filter chips work in reviewer mode',
    (tester) async {
      await _size(tester);
      await tester.pumpWidget(_app(const TinjauLaporanPage()));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('tinjau-filter-button')));
      await tester.pumpAndSettle();

      expect(
        find.byKey(const ValueKey('filter-belum-diperiksa')),
        findsOneWidget,
      );
      expect(
        find.byKey(const ValueKey('filter-sudah-diperiksa')),
        findsOneWidget,
      );

      // Filter by Belum Diperiksa -> only 'Belum Ditandai' rows (7 rows in TinjauLaporanPage)
      await tester.tap(find.byKey(const ValueKey('filter-belum-diperiksa')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('tinjau-filter-apply')));
      await tester.pumpAndSettle();

      expect(find.text('Belum Ditandai'), findsNWidgets(7));
      expect(find.text('Ditandai'), findsNothing);
      expect(find.text('Ditolak'), findsNothing);

      // Filter by Sudah Diperiksa -> only 'Ditandai' and 'Ditolak' rows (10 rows in TinjauLaporanPage)
      await tester.tap(find.byKey(const ValueKey('tinjau-filter-button')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const ValueKey('filter-sudah-diperiksa')));
      await tester.pump();
      await tester.tap(find.byKey(const ValueKey('tinjau-filter-apply')));
      await tester.pumpAndSettle();

      expect(find.text('Belum Ditandai'), findsNothing);
      expect(find.text('Ditandai'), findsNWidgets(7));
      expect(find.text('Ditolak'), findsNWidgets(3));
    },
  );

  testWidgets(
    'tiered approval status between Kepala Divisi and Kepala RS works with Tandai Di Terima button',
    (tester) async {
      await _size(tester);

      // 1. Kepala Divisi accepts row 1 ('Belum Ditandai' -> 'Ditandai' for Kepala Divisi)
      await tester.pumpWidget(_app(const TinjauLaporanPage(isKepalaRs: false)));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const ValueKey('tinjau-row-1')));
      await tester.pumpAndSettle();
      expect(find.text('Terima'), findsOneWidget);
      expect(find.text('Tandai Di Terima'), findsNothing);
      await tester.tap(find.byKey(const ValueKey('laporan-terima')));
      await tester.pumpAndSettle();

      expect(
        ReportStore.instance.statusFor('1', 'Belum Ditandai', isKepalaRs: false),
        'Ditandai',
      );
      // For Kepala RS, since Kepala Divisi accepted it, it is 'Belum Ditandai' until Kepala RS marks it!
      expect(
        ReportStore.instance.statusFor('1', 'Belum Ditandai', isKepalaRs: true),
        'Belum Ditandai',
      );

      // 2. Kepala RS opens dashboard -> TinjauLaporanPage(isKepalaRs: true)
      const rsHome = KepalaRsDashboardPage(
        profile: UserProfile(
          name: 'Dr. Hendra',
          email: 'rs@x.id',
          role: 'kepala_rs',
        ),
      );
      await tester.pumpWidget(_app(rsHome));
      await tester.pumpAndSettle();
      await tester.tap(_tinjau);
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: find.byKey(const ValueKey('tinjau-row-1')),
          matching: find.text('Belum Ditandai'),
        ),
        findsOneWidget,
      );

      // Kepala RS opens row 1 detail -> sees 'Tandai Di Terima' and taps it
      await tester.tap(find.byKey(const ValueKey('tinjau-row-1')));
      await tester.pumpAndSettle();
      expect(find.text('Tandai Di Terima'), findsOneWidget);
      await tester.tap(find.byKey(const ValueKey('laporan-terima')));
      await tester.pumpAndSettle();

      expect(
        ReportStore.instance.statusFor('1', 'Belum Ditandai', isKepalaRs: true),
        'Ditandai',
      );
      expect(
        find.descendant(
          of: find.byKey(const ValueKey('tinjau-row-1')),
          matching: find.text('Ditandai'),
        ),
        findsOneWidget,
      );
    },
  );

  for (final s in [const Size(360, 800), const Size(440, 956)]) {
    testWidgets('detail no overflow at ${s.width.toInt()}', (tester) async {
      await _size(tester, s);
      await tester.pumpWidget(
        _app(
          const LaporanDetailPage(
            title: 'Laporan xxx.xxx',
            author: 'Andi Facha H A',
            date: '05/10/2026',
            canReview: true,
            isKepalaRs: true,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'TinjauLaporanPage no overflow at ${s.width.toInt()}x${s.height.toInt()}',
      (tester) async {
        await _size(tester, s);
        await tester.pumpWidget(_app(const TinjauLaporanPage()));
        await tester.pumpAndSettle();
        expect(find.text('Tinjau Laporan'), findsOneWidget);
        expect(find.text('Divisi Apotek'), findsOneWidget);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
