import 'package:flutter/material.dart';

import 'constants/app_colors.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/data_carousel_card.dart';
import 'widgets/floating_action_bar.dart';
import 'data/mock_dashboard_data.dart';
import 'data_summary_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _summaryPageIndex = 2; // Active dot is 3rd in screenshot
  int _reportPageIndex = 0; // Active dot is 1st in screenshot

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGray,
      body: SafeArea(
        child: Column(
          children: [
            const DashboardHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1: Ringkasan Data Bulan Austus
                    _buildSectionHeader('Ringkasan Data Bulan Austus'),
                    const SizedBox(height: 10),
                    DataCarouselCard(
                      cardTitle: 'Ringkasan Data Bulan Austus',
                      headers: const ['No', 'Nama obat', 'Satuan', 'Jumlah'],
                      columnWidths: const [38, null, null, 56],
                      columnFlexes: const [0, 4, 3, 0],
                      rows: MockDashboardData.medicineStocks
                          .map((e) => e.toRowData())
                          .toList(),
                      activeDotIndex: _summaryPageIndex,
                      totalDots: 6,
                      onPrev: () {
                        if (_summaryPageIndex > 0) {
                          setState(() => _summaryPageIndex--);
                        }
                      },
                      onNext: () {
                        if (_summaryPageIndex < 5) {
                          setState(() => _summaryPageIndex++);
                        }
                      },
                      onCardTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DataSummaryPage(),
                          ),
                        );
                      },
                    ),

                    const SizedBox(height: 24),

                    // Section 2: Laporan Divisi Terbaru
                    _buildSectionHeader('Laporan Divisi Terbaru'),
                    const SizedBox(height: 10),
                    DataCarouselCard(
                      cardTitle: 'Laporan Terbaru Divisi Apotek',
                      headers: const [
                        'No',
                        'Nama Laporan',
                        'Aurthor',
                        'Tanggal',
                      ],
                      columnWidths: const [36, null, null, 78],
                      columnFlexes: const [0, 4, 4, 0],
                      rows: MockDashboardData.reports
                          .map((e) => e.toRowData())
                          .toList(),
                      activeDotIndex: _reportPageIndex,
                      totalDots: 6,
                      onPrev: () {
                        if (_reportPageIndex > 0) {
                          setState(() => _reportPageIndex--);
                        }
                      },
                      onNext: () {
                        if (_reportPageIndex < 5) {
                          setState(() => _reportPageIndex++);
                        }
                      },
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            FloatingActionBar(
              onInputLaporan: () {},
              onLaporanSaya: () {},
              onLogout: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w800,
          color: AppColors.black,
          letterSpacing: -0.2,
        ),
      ),
    );
  }
}
