import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_bagus/dashboard_page.dart';
import 'package:app_bagus/kepala_divisi_dashboard_page.dart';
import 'package:app_bagus/kepala_rs_dashboard_page.dart';
import 'package:app_bagus/models/user_profile.dart';
import 'package:app_bagus/staff_dashboard_page.dart';

Widget _app(UserProfile profile) => MaterialApp(
  theme: ThemeData(fontFamily: 'SF Pro Display'),
  home: DashboardPage(profile: profile),
);

void main() {
  testWidgets('staff dashboard shows Input Laporan and Laporan Saya', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const UserProfile(
          email: 'staff@harmoni.com',
          name: 'Siti Rahmawati',
          role: 'staff_divisi',
          division: 'Rawat Inap',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(StaffDashboardPage), findsOneWidget);
    expect(find.text('Input Laporan'), findsOneWidget);
    expect(find.text('Laporan Saya'), findsOneWidget);
    expect(find.text('Tinjau Laporan Masuk'), findsNothing);
    expect(find.text('Siti Rahmawati'), findsOneWidget);
    expect(find.text('Divisi Rawat Inap'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('kepala divisi dashboard only shows Tinjau Laporan Masuk', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const UserProfile(
          email: 'kadiv@harmoni.com',
          name: 'Agus Santoso',
          role: 'kepala_divisi',
          division: 'Rawat Inap',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(KepalaDivisiDashboardPage), findsOneWidget);
    expect(find.text('Tinjau Laporan Masuk'), findsOneWidget);
    expect(find.text('Input Laporan'), findsNothing);
    expect(find.text('Laporan Saya'), findsNothing);
    expect(find.text('Agus Santoso'), findsOneWidget);
    expect(find.text('Kepala Divisi Rawat Inap'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets(
    'kepala RS dashboard only shows Tinjau Laporan Masuk and no division',
    (tester) async {
      await tester.pumpWidget(
        _app(
          const UserProfile(
            email: 'karumkit@harmoni.com',
            name: 'Budiono Siregar',
            role: 'kepala_rs',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(KepalaRsDashboardPage), findsOneWidget);
      expect(find.byType(KepalaDivisiDashboardPage), findsNothing);
      expect(find.text('Tinjau Laporan Masuk'), findsOneWidget);
      expect(find.text('Input Laporan'), findsNothing);
      expect(find.text('Laporan Saya'), findsNothing);
      expect(find.text('Budiono Siregar'), findsOneWidget);
      expect(find.text('Kepala Rumah Sakit'), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  for (final size in [const Size(360, 800), const Size(440, 956)]) {
    testWidgets(
      'kepala divisi dashboard no overflow at ${size.width.toInt()}x${size.height.toInt()}',
      (tester) async {
        await tester.binding.setSurfaceSize(size);
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.pumpWidget(
          _app(
            const UserProfile(
              email: 'kadiv@harmoni.com',
              name: 'Agus Santoso',
              role: 'kepala_divisi',
              division: 'Rawat Inap',
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
      },
    );
  }
}
