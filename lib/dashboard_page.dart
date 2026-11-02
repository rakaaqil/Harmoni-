import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'change_password_page.dart';
import 'constants/app_colors.dart';
import 'data_summary_page.dart';
import 'input_laporan_page.dart';
import 'laporan_divisi_page.dart';
import 'login_page.dart';
import 'laporan_saya_page.dart';
import 'widgets/dashboard_header.dart';
import 'widgets/floating_action_bar.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
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
                          card: _ChartCard(
                            onTap: () => _push(const DataSummaryPage()),
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
                          card: _ReportCard(
                            onTap: () => _push(const LaporanDivisiPage()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                FloatingActionBar(
                  onInputLaporan: () => _push(const InputLaporanPage()),
                  onLaporanSaya: () => _push(const LaporanSayaPage()),
                ),
              ],
            ),
            if (_profileMenuOpen) ...[
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => setState(() => _profileMenuOpen = false),
                ),
              ),
              Positioned(
                child: CompositedTransformFollower(
                  link: _profileLink,
                  targetAnchor: Alignment.bottomCenter,
                  followerAnchor: Alignment.topCenter,
                  offset: const Offset(0, 4),
                  showWhenUnlinked: false,
                  child: Container(
                    width: 168,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x40000000),
                          blurRadius: 14,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _profileAction(
                          key: const ValueKey('profile-menu-change-password'),
                          label: 'Ganti Password',
                          onTap: () {
                            setState(() => _profileMenuOpen = false);
                            _push(const ChangePasswordPage());
                          },
                        ),
                        const SizedBox(height: 8),
                        _profileAction(
                          key: const ValueKey('profile-menu-logout'),
                          label: 'KELUAR',
                          labelColor: AppColors.logoutRed,
                          onTap: () {
                            setState(() => _profileMenuOpen = false);
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                              (route) => false,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _push(Widget page) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  Widget _profileAction({
    required Key key,
    required String label,
    required VoidCallback onTap,
    Color labelColor = AppColors.black,
  }) => GestureDetector(
    key: key,
    onTap: onTap,
    child: Container(
      width: double.infinity,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.rowGray,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E5E5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: labelColor,
        ),
      ),
    ),
  );

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
      _PagerDots(active: index),
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

class _Panel extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const _Panel({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Color(0x45000000),
            blurRadius: 15,
            spreadRadius: 2,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: child,
    ),
  );
}

class _ChartCard extends StatelessWidget {
  final VoidCallback onTap;
  const _ChartCard({required this.onTap});

  @override
  Widget build(BuildContext context) => _Panel(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 12),
      child: Column(
        children: [
          const Text(
            'Chart Obat Keluar Dalam 5 Bulan Terakhir',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const SizedBox(height: 7),
          SizedBox(
            height: 149,
            child: CustomPaint(size: Size.infinite, painter: _ChartPainter()),
          ),
          const SizedBox(height: 5),
          const _Legend(),
        ],
      ),
    ),
  );
}

class _ChartPainter extends CustomPainter {
  static const _colors = [
    Color(0xff6968ff),
    Color(0xff41bfaa),
    Color(0xffff7d79),
    Color(0xff29b9dc),
    Color(0xffffa13d),
  ];
  static const _points = [
    [12, 50, 0, 65, 41],
    [92, 60, 95, 36, 10],
    [72, 60, 38, 0, 60],
    [75, 14, 80, 37, 47],
    [84, 92, 82, 68, 37],
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final plot = Rect.fromLTWH(32, 4, size.width - 40, size.height - 26);
    final line = Paint()
      ..color = const Color(0xffd5d5d5)
      ..strokeWidth = 1;
    for (var i = 0; i <= 5; i++) {
      final y = plot.top + plot.height * i / 5;
      canvas.drawLine(Offset(plot.left, y), Offset(plot.right, y), line);
      if (i < 5) {
        canvas.drawLine(
          Offset(plot.left + plot.width * i / 4, plot.top),
          Offset(plot.left + plot.width * i / 4, plot.bottom),
          line,
        );
      }
      final value = TextPainter(
        text: TextSpan(
          text: '${100 - i * 20}',
          style: const TextStyle(fontSize: 9, color: Color(0xff555555)),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      value.paint(canvas, Offset(3, y - 5));
    }
    for (var series = 0; series < _points.length; series++) {
      final path = Path();
      for (var i = 0; i < 5; i++) {
        final point = Offset(
          plot.left + plot.width * i / 4,
          plot.bottom - plot.height * _points[series][i] / 100,
        );
        i == 0
            ? path.moveTo(point.dx, point.dy)
            : path.lineTo(point.dx, point.dy);
      }
      canvas.drawPath(
        path,
        Paint()
          ..color = _colors[series]
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.8,
      );
      for (var i = 0; i < 5; i++) {
        final point = Offset(
          plot.left + plot.width * i / 4,
          plot.bottom - plot.height * _points[series][i] / 100,
        );
        canvas.drawCircle(point, 3.1, Paint()..color = Colors.white);
        canvas.drawCircle(
          point,
          3.1,
          Paint()
            ..color = _colors[series]
            ..style = PaintingStyle.stroke
            ..strokeWidth = 1.1,
        );
      }
    }
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May'];
    for (var i = 0; i < months.length; i++) {
      final text = TextPainter(
        text: TextSpan(
          text: months[i],
          style: const TextStyle(fontSize: 10, color: Color(0xff555555)),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      text.paint(
        canvas,
        Offset(
          plot.left + plot.width * i / 4 - text.width / 2,
          plot.bottom + 8,
        ),
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Legend extends StatelessWidget {
  const _Legend();
  @override
  Widget build(BuildContext context) {
    const labels = [
      'Paracetamol',
      'Amoxicillin',
      'Omeprazole',
      'Cetirizine',
      'RingerLaktat',
    ];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(
        labels.length,
        (i) => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 11, height: 1.5, color: _ChartPainter._colors[i]),
            const SizedBox(width: 2),
            Text(
              labels[i],
              style: const TextStyle(fontSize: 6.8, color: Color(0xff4a4a4a)),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final VoidCallback onTap;
  const _ReportCard({required this.onTap});

  @override
  Widget build(BuildContext context) => _Panel(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 10),
      child: Column(
        children: [
          const Text(
            'Laporan Terbaru Divisi Apotek',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: Column(
              children: [
                _row(const [
                  'No',
                  'Nama Laporan',
                  'Aurthor',
                  'Tanggal',
                ], header: true),
                ...List.generate(
                  6,
                  (i) => _row([
                    '${i + 1}',
                    'Laporan xxx.xxx',
                    i.isEven ? 'Andi Facha H A' : 'M Rakha Aqil S',
                    '05/10/2026',
                  ], shade: i.isOdd),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget _row(List<String> cells, {bool header = false, bool shade = false}) =>
      Container(
        color: header
            ? AppColors.teal
            : (shade ? const Color(0xfff3f3f3) : Colors.white),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          children: [
            SizedBox(width: 27, child: _cell(cells[0], header)),
            Expanded(flex: 4, child: _cell(cells[1], header)),
            Expanded(flex: 4, child: _cell(cells[2], header)),
            SizedBox(
              width: 67,
              child: _cell(cells[3], header, align: TextAlign.right),
            ),
          ],
        ),
      );

  Widget _cell(String value, bool header, {TextAlign align = TextAlign.left}) =>
      Text(
        value,
        textAlign: align,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: 11,
          color: header ? Colors.white : Colors.black,
          fontWeight: header ? FontWeight.w500 : FontWeight.w400,
        ),
      );
}

class _PagerDots extends StatelessWidget {
  final int active;
  const _PagerDots({required this.active});
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
    decoration: BoxDecoration(
      color: const Color(0xffdddddd),
      borderRadius: BorderRadius.circular(15),
      boxShadow: const [
        BoxShadow(
          color: Color(0x38000000),
          blurRadius: 4,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        6,
        (i) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 2.5),
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: i == active ? AppColors.teal : Colors.white,
          ),
        ),
      ),
    ),
  );
}
