import 'package:flutter/material.dart';

import 'input_laporan_page.dart';
import 'laporan_saya_page.dart';
import 'models/user_profile.dart';
import 'widgets/floating_action_bar.dart';
import 'widgets/role_dashboard_scaffold.dart';

class StaffDashboardPage extends StatelessWidget {
  final UserProfile profile;
  const StaffDashboardPage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    final div = profile.division?.trim();
    final subtitle = (div == null || div.isEmpty)
        ? 'Divisi Apotek'
        : (div.toLowerCase().startsWith('divisi') ? div : 'Divisi $div');

    return RoleDashboardScaffold(
      name: profile.name,
      headerSubtitle: subtitle,
      bottomBar: FloatingActionBar(
        onInputLaporan: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const InputLaporanPage()),
        ),
        onLaporanSaya: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LaporanSayaPage()),
        ),
      ),
    );
  }
}
