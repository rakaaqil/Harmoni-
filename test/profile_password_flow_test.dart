import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:app_bagus/change_password_page.dart';
import 'package:app_bagus/dashboard_page.dart';
import 'package:app_bagus/login_page.dart';
import 'package:app_bagus/models/user_profile.dart';

const _profile = UserProfile(
  email: 'staff@harmoni.com',
  name: 'Staf Rawat Inap',
  role: 'staff_divisi',
  division: 'Rawat Inap',
);

Widget _app({required Widget home}) => MaterialApp(
  theme: ThemeData(fontFamily: 'SF Pro Display'),
  home: home,
);

Future<void> _openChangePassword(WidgetTester tester) async {
  await tester.pumpWidget(_app(home: const DashboardPage(profile: _profile)));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const ValueKey('profile-button')));
  await tester.pumpAndSettle();
  await tester.tap(find.byKey(const ValueKey('profile-menu-change-password')));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('profile button opens profile menu', (tester) async {
    await tester.pumpWidget(_app(home: const DashboardPage(profile: _profile)));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('profile-button')));
    await tester.pumpAndSettle();

    expect(find.text('Ganti Password'), findsOneWidget);
    expect(find.text('KELUAR'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('profile-menu-change-password')),
      findsOneWidget,
    );
    expect(find.byKey(const ValueKey('profile-menu-logout')), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('change password menu action opens change password page', (
    tester,
  ) async {
    await _openChangePassword(tester);

    expect(find.byType(ChangePasswordPage), findsOneWidget);
    expect(find.byKey(const ValueKey('change-password-old')), findsOneWidget);
    expect(find.byKey(const ValueKey('change-password-new')), findsOneWidget);
    expect(
      find.byKey(const ValueKey('change-password-confirm')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('change-password-submit')),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('back button returns from change password page', (tester) async {
    await _openChangePassword(tester);

    await tester.tap(find.byIcon(Icons.chevron_left_rounded));
    await tester.pumpAndSettle();

    expect(find.byType(DashboardPage), findsOneWidget);
    expect(find.byType(ChangePasswordPage), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('wrong old password shows error and stays on page', (
    tester,
  ) async {
    await _openChangePassword(tester);

    await tester.enterText(
      find.byKey(const ValueKey('change-password-old')),
      '000000',
    );
    await tester.enterText(
      find.byKey(const ValueKey('change-password-new')),
      'abc',
    );
    await tester.enterText(
      find.byKey(const ValueKey('change-password-confirm')),
      'abc',
    );
    await tester.tap(find.byKey(const ValueKey('change-password-submit')));
    await tester.pump();

    expect(find.text('Password lama salah'), findsOneWidget);
    expect(find.byType(ChangePasswordPage), findsOneWidget);
  });

  testWidgets('empty new password shows error', (tester) async {
    await _openChangePassword(tester);

    await tester.enterText(
      find.byKey(const ValueKey('change-password-old')),
      '123456',
    );
    await tester.tap(find.byKey(const ValueKey('change-password-submit')));
    await tester.pump();

    expect(find.text('Password baru tidak boleh kosong'), findsOneWidget);
    expect(find.byType(ChangePasswordPage), findsOneWidget);
  });

  testWidgets('mismatched confirmation shows error', (tester) async {
    await _openChangePassword(tester);

    await tester.enterText(
      find.byKey(const ValueKey('change-password-old')),
      '123456',
    );
    await tester.enterText(
      find.byKey(const ValueKey('change-password-new')),
      'abc',
    );
    await tester.enterText(
      find.byKey(const ValueKey('change-password-confirm')),
      'xyz',
    );
    await tester.tap(find.byKey(const ValueKey('change-password-submit')));
    await tester.pump();

    expect(find.text('Konfirmasi password tidak sama'), findsOneWidget);
    expect(find.byType(ChangePasswordPage), findsOneWidget);
  });

  testWidgets('valid password change resets navigation to login', (
    tester,
  ) async {
    await _openChangePassword(tester);

    await tester.enterText(
      find.byKey(const ValueKey('change-password-old')),
      '123456',
    );
    await tester.enterText(
      find.byKey(const ValueKey('change-password-new')),
      'new-password',
    );
    await tester.enterText(
      find.byKey(const ValueKey('change-password-confirm')),
      'new-password',
    );
    await tester.tap(find.byKey(const ValueKey('change-password-submit')));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.text('MASUK'), findsNWidgets(2));
    expect(find.byType(ChangePasswordPage), findsNothing);
  });

  testWidgets('logout resets navigation to login', (tester) async {
    await tester.pumpWidget(_app(home: const DashboardPage(profile: _profile)));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const ValueKey('profile-button')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('profile-menu-logout')));
    await tester.pumpAndSettle();

    expect(find.byType(LoginPage), findsOneWidget);
    expect(find.text('MASUK'), findsNWidgets(2));
    expect(find.byType(DashboardPage), findsNothing);
  });

  for (final size in [const Size(360, 800), const Size(440, 956)]) {
    testWidgets(
      'change password has no overflow at ${size.width.toInt()}x${size.height.toInt()}',
      (tester) async {
        await tester.binding.setSurfaceSize(size);
        addTearDown(() => tester.binding.setSurfaceSize(null));
        await tester.pumpWidget(_app(home: const ChangePasswordPage()));
        await tester.pumpAndSettle();

        expect(tester.takeException(), isNull);
      },
    );
  }
}
