import 'package:flutter/material.dart';

import 'admin_data_pengguna_page.dart';
import 'kepala_divisi_dashboard_page.dart';
import 'kepala_rs_dashboard_page.dart';
import 'models/user_profile.dart';
import 'staff_dashboard_page.dart';

class DashboardPage extends StatelessWidget {
  final UserProfile profile;
  const DashboardPage({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    if (profile.isSuperAdmin) return const AdminDataPenggunaPage();
    if (profile.role == 'kepala_rs') {
      return KepalaRsDashboardPage(profile: profile);
    }
    if (profile.role == 'kepala_divisi') {
      return KepalaDivisiDashboardPage(profile: profile);
    }
    return StaffDashboardPage(profile: profile);
  }
}
