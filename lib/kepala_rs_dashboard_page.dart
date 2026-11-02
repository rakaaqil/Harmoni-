import 'package:flutter/material.dart';

import 'models/user_profile.dart';
import 'tinjau_laporan_page.dart';
import 'widgets/review_bar.dart';
import 'widgets/role_dashboard_scaffold.dart';

/// Dashboard Kepala Rumah Sakit dengan navigasi ke peninjauan laporan lanjutan.
class KepalaRsDashboardPage extends StatelessWidget {
  final UserProfile profile;
  const KepalaRsDashboardPage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return RoleDashboardScaffold(
      name: profile.name,
      headerSubtitle: 'Kepala Rumah Sakit',
      isReviewer: true,
      isKepalaRs: true,
      bottomBar: ReviewBar(
        buttonKey: const ValueKey('tinjau-laporan-masuk'),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const TinjauLaporanPage(isKepalaRs: true),
          ),
        ),
      ),
    );
  }
}
