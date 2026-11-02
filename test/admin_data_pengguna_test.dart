import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_bagus/admin_data_pengguna_page.dart';

final _sampleUsers = [
  {
    'name': 'Staf Rawat Inap',
    'email': 'staff@harmoni.com',
    'role': 'staff_divisi',
    'division': 'Rawat Inap',
    'status': 'aktif',
  },
  {
    'name': 'Kepala Divisi Rawat Inap',
    'email': 'kadiv@harmoni.com',
    'role': 'kepala_divisi',
    'division': 'Rawat Inap',
    'status': 'aktif',
  },
  {
    'name': 'Staf Apotek Nonaktif',
    'email': 'apotek@harmoni.com',
    'role': 'staff',
    'division': 'Apotek',
    'status': 'nonaktif',
  },
  {
    'name': 'Kepala Rumah Sakit',
    'email': 'karumkit@harmoni.com',
    'role': 'kepala_rs',
    'status': 'aktif',
  },
  {'name': 'admin', 'email': 'admin@gmail.com', 'role': 'super_admin'},
];

Stream<List<Map<String, dynamic>>> _stream() async* {
  yield _sampleUsers;
}

Widget _app() => MaterialApp(
  theme: ThemeData(fontFamily: 'SF Pro Display'),
  home: const AdminDataPenggunaPage(usersStream: _stream),
);

void main() {
  testWidgets('admin page lists all users', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('user-staff@harmoni.com')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('user-admin@gmail.com')), findsOneWidget);
    expect(find.text('Data Pengguna'), findsOneWidget);
    expect(find.byKey(const ValueKey('admin-search')), findsOneWidget);
    expect(find.byKey(const ValueKey('admin-add')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('admin page search filters by email', (tester) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const ValueKey('admin-search')), 'kadiv');
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('user-kadiv@harmoni.com')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('user-staff@harmoni.com')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('tapping a user row opens Edit Pengguna sheet with Ubah and Nonaktifkan', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('user-staff@harmoni.com')));
    await tester.pumpAndSettle();

    expect(find.text('Edit Pengguna'), findsNWidgets(2));
    expect(find.byKey(const ValueKey('admin-name')), findsOneWidget);
    expect(find.byKey(const ValueKey('admin-division')), findsOneWidget);
    expect(find.byKey(const ValueKey('admin-role')), findsOneWidget);
    expect(find.byKey(const ValueKey('admin-cancel')), findsOneWidget);
    expect(find.text('Batal'), findsOneWidget);
    expect(find.byKey(const ValueKey('admin-save')), findsOneWidget);
    expect(find.text('Ubah'), findsOneWidget);
    expect(find.byKey(const ValueKey('admin-toggle-status')), findsOneWidget);
    expect(find.text('Nonaktifkan'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('admin-division')));
    await tester.pumpAndSettle();
    expect(find.text('Apotek'), findsWidgets);

    await tester.tap(find.text('Apotek').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('admin-cancel')));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('user-apotek@harmoni.com')));
    await tester.pumpAndSettle();
    expect(find.text('Aktifkan'), findsOneWidget);

    expect(tester.takeException(), isNull);
  });

  testWidgets('tapping Tambah Pengguna opens Tambah Pengguna without Nonaktifkan', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('admin-add')));
    await tester.pumpAndSettle();

    expect(find.text('Tambah Pengguna'), findsNWidgets(2));
    expect(find.byKey(const ValueKey('admin-name')), findsOneWidget);
    expect(find.byKey(const ValueKey('admin-division')), findsOneWidget);
    expect(find.byKey(const ValueKey('admin-role')), findsOneWidget);
    expect(find.byKey(const ValueKey('admin-cancel')), findsOneWidget);
    expect(find.text('Batal'), findsOneWidget);
    expect(find.byKey(const ValueKey('admin-save')), findsOneWidget);
    expect(find.text('Tambah'), findsOneWidget);
    expect(find.byKey(const ValueKey('admin-toggle-status')), findsNothing);
    expect(find.text('Nonaktifkan'), findsNothing);

    expect(tester.takeException(), isNull);
  });

  testWidgets('admin page no overflow at 360x800 and 440x956', (tester) async {
    await tester.binding.setSurfaceSize(const Size(360, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.binding.setSurfaceSize(const Size(440, 956));
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('admin filter sheet filters by role, division, and status', (
    tester,
  ) async {
    await tester.pumpWidget(_app());
    await tester.pumpAndSettle();

    // Open filter sheet
    await tester.tap(find.byKey(const ValueKey('admin-filter')));
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('admin-filter-role')), findsOneWidget);
    expect(find.byKey(const ValueKey('admin-filter-division')), findsOneWidget);
    expect(find.byKey(const ValueKey('admin-filter-status')), findsOneWidget);

    // Filter by status = nonaktif
    await tester.tap(find.byKey(const ValueKey('admin-filter-status')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Nonaktif').last);
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('user-apotek@harmoni.com')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('user-staff@harmoni.com')), findsNothing);
    expect(find.byKey(const ValueKey('user-kadiv@harmoni.com')), findsNothing);

    // Reset filter
    await tester.tap(find.byKey(const ValueKey('admin-filter-reset')));
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('user-staff@harmoni.com')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('user-apotek@harmoni.com')),
      findsOneWidget,
    );

    // Filter by division = Rawat Inap and role = kepala_divisi
    await tester.tap(find.byKey(const ValueKey('admin-filter-division')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Rawat Inap').last);
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('admin-filter-role')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Kepala Divisi').last);
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('user-kadiv@harmoni.com')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('user-staff@harmoni.com')), findsNothing);
    expect(tester.takeException(), isNull);
  });
}
