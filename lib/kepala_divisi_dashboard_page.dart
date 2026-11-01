import 'package:flutter/material.dart';

import 'models/user_profile.dart';
import 'tinjau_laporan_page.dart';
import 'widgets/review_bar.dart';
import 'widgets/role_dashboard_scaffold.dart';

class KepalaDivisiDashboardPage extends StatelessWidget {
  final UserProfile profile;
  const KepalaDivisiDashboardPage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final div = profile.division?.trim();
    final subtitle = (div == null || div.isEmpty)
        ? 'Kepala Divisi Apotek'
        : (div.toLowerCase().startsWith('kepala divisi')
              ? div
              : 'Kepala Divisi $div');

    return RoleDashboardScaffold(
      name: profile.name,
      headerSubtitle: subtitle,
      isReviewer: true,
      bottomBar: ReviewBar(
        buttonKey: const ValueKey('tinjau-laporan-masuk'),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const TinjauLaporanPage(),
          ),
        ),
      ),
    );
  }
}
