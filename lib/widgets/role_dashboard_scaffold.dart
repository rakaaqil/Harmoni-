import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../change_password_page.dart';
import '../constants/app_colors.dart';
import '../data_summary_page.dart';
import '../laporan_divisi_page.dart';
import '../login_page.dart';
import 'chart_card.dart';
import 'dashboard_header.dart';
import 'pager_dots.dart';
import 'profile_menu_overlay.dart';
import 'report_card.dart';

class RoleDashboardScaffold extends StatefulWidget {
  final String name;
  final String? headerSubtitle;
  final Widget bottomBar;
  final bool isReviewer;
  final bool isKepalaRs;

  const RoleDashboardScaffold({
    super.key,
    required this.name,
    required this.headerSubtitle,
    required this.bottomBar,
    this.isReviewer = false,
    this.isKepalaRs = false,
  });

  @override
  State<RoleDashboardScaffold> createState() => _RoleDashboardScaffoldState();
}

class _RoleDashboardScaffoldState extends State<RoleDashboardScaffold> {
  int _chartIndex = 2;
  int _reportIndex = 0;
  bool _profileMenuOpen = false;
  final _profileLink = LayerLink();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGray,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                DashboardHeader(
                  name: widget.name,
                  division: widget.headerSubtitle,
                  onProfileTap: () =>
                      setState(() => _profileMenuOpen = !_profileMenuOpen),
                  profileLink: _profileLink,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(top: 41, bottom: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _title('Ringkasan Data Bulan Austus'),
                        const SizedBox(height: 14),
                        _carousel(
                          index: _chartIndex,
                          onPrevious: () => setState(
                            () => _chartIndex = math.max(0, _chartIndex - 1),
                          ),
                          onNext: () => setState(
                            () => _chartIndex = math.min(5, _chartIndex + 1),
                          ),
                          card: ChartCard(
                            onTap: () => _push(
                              DataSummaryPage(
                                isReviewer: widget.isReviewer,
                                isKepalaRs: widget.isKepalaRs,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 23),
                        _title('Laporan Divisi Terbaru'),
                        const SizedBox(height: 11),
                        _carousel(
                          index: _reportIndex,
                          onPrevious: () => setState(
                            () => _reportIndex = math.max(0, _reportIndex - 1),
                          ),
                          onNext: () => setState(
                            () => _reportIndex = math.min(5, _reportIndex + 1),
                          ),
                          card: ReportCard(
                            onTap: () => _push(
                              LaporanDivisiPage(
                                isReviewer: widget.isReviewer,
                                isKepalaRs: widget.isKepalaRs,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                widget.bottomBar,
              ],
            ),
            if (_profileMenuOpen)
              Positioned.fill(
                child: ProfileMenuOverlay(
                  profileLink: _profileLink,
                  onClose: () => setState(() => _profileMenuOpen = false),
                  onChangePassword: () {
                    setState(() => _profileMenuOpen = false);
                    _push(const ChangePasswordPage());
                  },
                  onLogout: () {
                    setState(() => _profileMenuOpen = false);
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const LoginPage()),
                      (route) => false,
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _push(Widget page) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  Widget _title(String value) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 37),
    child: Text(
      value,
      style: const TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.w800,
        height: 1,
      ),
    ),
  );

  Widget _carousel({
    required int index,
    required VoidCallback onPrevious,
    required VoidCallback onNext,
    required Widget card,
  }) => Column(
    children: [
      Row(
        children: [
          _pagerButton(Icons.chevron_left_rounded, onPrevious),
          Expanded(child: card),
          _pagerButton(Icons.chevron_right_rounded, onNext),
        ],
      ),
      const SizedBox(height: 10),
      PagerDots(active: index),
    ],
  );

  Widget _pagerButton(IconData icon, VoidCallback onTap) => SizedBox(
    width: 37,
    child: Center(
      child: InkResponse(
        onTap: onTap,
        radius: 18,
        child: Container(
          width: 29,
          height: 29,
          decoration: const BoxDecoration(
            color: Color(0xffd5d5d5),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x35000000),
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 22, color: const Color(0xff292929)),
        ),
      ),
    ),
  );
}
