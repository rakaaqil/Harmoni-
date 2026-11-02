import 'package:flutter/material.dart';

import 'constants/app_colors.dart';
import 'tinjau_laporan_page.dart';
import 'widgets/review_bar.dart';

/// Static staff summary matched to 440x956 reference.
class DataSummaryPage extends StatefulWidget {
  final bool isReviewer;
  final bool isKepalaRs;

  const DataSummaryPage({
    super.key,
    this.isReviewer = false,
    this.isKepalaRs = false,
  });

  @override
  State<DataSummaryPage> createState() => _DataSummaryPageState();
}

class _DataSummaryPageState extends State<DataSummaryPage> {
  int _selectedYear = 2026;
  int _selectedMonth = 12;
  String _selectedDivision = 'Divisi Apotek';
  bool _showDatePopup = false;
  bool _showDivisionSidebar = false;

  static const _divisions = [
    'Divisi Apotek',
    'Divisi Kebidanan',
    'Divisi Pendaftaran',
    'Divisi Rawat Inap',
    'Divisi Rawat Jalan',
    'Divisi UGD',
  ];

  String get _formattedDate =>
      '$_selectedYear,${_selectedMonth.toString().padLeft(2, '0')}';

  void _prevMonth() {
    setState(() {
      if (_selectedMonth == 1) {
        _selectedMonth = 12;
        _selectedYear--;
      } else {
        _selectedMonth--;
      }
    });
  }

  void _nextMonth() {
    setState(() {
      if (_selectedMonth == 12) {
        _selectedMonth = 1;
        _selectedYear++;
      } else {
        _selectedMonth++;
      }
    });
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(_selectedYear, _selectedMonth, 1),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedYear = picked.year;
        _selectedMonth = picked.month;
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      bottom: false,
      child: Column(
        children: [
          _SummaryHeader(onBack: () => Navigator.pop(context)),
          Expanded(
            child: Stack(
              children: [
                ColoredBox(
                  color: AppColors.bgGray,
                  child: Column(
                    children: [
                      const SizedBox(height: 11),
                      _SummaryFilter(
                        division: _selectedDivision,
                        dateText: _formattedDate,
                        onDivisionTap: () =>
                            setState(() => _showDivisionSidebar = true),
                        onDateTap: () =>
                            setState(() => _showDatePopup = !_showDatePopup),
                      ),
                      const SizedBox(height: 17),
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 23),
                          itemCount: 5,
                          separatorBuilder: (_, _) =>
                              const SizedBox(height: 27),
                          itemBuilder: (_, _) => const _UsageChartCard(),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_showDatePopup) ...[
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() => _showDatePopup = false),
                    ),
                  ),
                  Positioned(
                    top: 60,
                    right: 17,
                    child: _DateNavPopup(
                      dateText: _formattedDate,
                      onPrev: _prevMonth,
                      onNext: _nextMonth,
                      onCalendar: _pickDate,
                    ),
                  ),
                ],
                if (_showDivisionSidebar) ...[
                  Positioned.fill(
                    child: GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => setState(() => _showDivisionSidebar = false),
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    bottom: 0,
                    child: _DivisionSidebar(
                      divisions: _divisions,
                      selectedDivision: _selectedDivision,
                      onSelect: (division) => setState(() {
                        _selectedDivision = division;
                        _showDivisionSidebar = false;
                      }),
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (widget.isReviewer)
            ColoredBox(
              color: AppColors.bgGray,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: ReviewBar(
                  buttonKey: const ValueKey('tinjau-laporan-masuk'),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          TinjauLaporanPage(isKepalaRs: widget.isKepalaRs),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

class _SummaryHeader extends StatelessWidget {
  final VoidCallback onBack;
  const _SummaryHeader({required this.onBack});

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    height: 66,
    color: Colors.white,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          left: 30,
          child: InkResponse(
            onTap: onBack,
            radius: 22,
            child: Container(
              width: 41,
              height: 41,
              decoration: const BoxDecoration(
                color: Color(0xFFD9D9D9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                size: 24,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
        ),
        const Text(
          'Ringkasan Data',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            height: 1,
            letterSpacing: -0.4,
            color: Colors.black,
          ),
        ),
      ],
    ),
  );
}

class _SummaryFilter extends StatelessWidget {
  final String division;
  final String dateText;
  final VoidCallback onDivisionTap;
  final VoidCallback onDateTap;

  const _SummaryFilter({
    required this.division,
    required this.dateText,
    required this.onDivisionTap,
    required this.onDateTap,
  });

  @override
  Widget build(BuildContext context) => Container(
    height: 45,
    margin: const EdgeInsets.symmetric(horizontal: 17),
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(23),
      border: Border.all(color: const Color(0xFFE3E3E3), width: 1),
      boxShadow: const [
        BoxShadow(
          color: Color(0x26000000),
          blurRadius: 8,
          offset: Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      children: [
        GestureDetector(
          key: const ValueKey('division-sidebar-toggle'),
          onTap: onDivisionTap,
          child: Container(
            width: 37,
            height: 37,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x33000000),
                  blurRadius: 5,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: const Icon(
              Icons.chevron_right_rounded,
              size: 26,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ),
        Expanded(
          child: Text(
            division,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.4,
              color: Colors.black,
            ),
          ),
        ),
        GestureDetector(
          onTap: onDateTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFD9D9D9), width: 1),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x1F000000),
                  blurRadius: 4,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Text(
              dateText,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.3,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

class _DivisionSidebar extends StatelessWidget {
  final List<String> divisions;
  final String selectedDivision;
  final ValueChanged<String> onSelect;

  const _DivisionSidebar({
    required this.divisions,
    required this.selectedDivision,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    elevation: 8,
    child: SizedBox(
      width: 228,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(19, 12, 25, 0),
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: divisions.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              final division = divisions[index];
              final selected = division == selectedDivision;
              return GestureDetector(
                key: ValueKey('division-$division'),
                onTap: () => onSelect(division),
                child: Container(
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF16B5AE)
                        : const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    division,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    ),
  );
}

class _DateNavPopup extends StatelessWidget {
  final String dateText;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback onCalendar;
  const _DateNavPopup({
    required this.dateText,
    required this.onPrev,
    required this.onNext,
    required this.onCalendar,
  });

  Widget _roundButton(
    IconData icon,
    double iconSize,
    VoidCallback onTap, {
    Key? key,
  }) => GestureDetector(
    key: key,
    onTap: onTap,
    child: Container(
      width: 32,
      height: 32,
      decoration: const BoxDecoration(
        color: Color(0xFFD9D9D9),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: iconSize, color: const Color(0xFF1A1A1A)),
    ),
  );

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 5),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: const Color(0xFFE8E8E8), width: 1),
      boxShadow: const [
        BoxShadow(
          color: Color(0x33000000),
          blurRadius: 10,
          offset: Offset(0, 4),
        ),
      ],
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _roundButton(
          Icons.chevron_left_rounded,
          20,
          onPrev,
          key: const ValueKey('date-popup-prev'),
        ),
        const SizedBox(width: 6),
        Container(
          height: 32,
          padding: const EdgeInsets.symmetric(horizontal: 14),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            dateText,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A1A),
            ),
          ),
        ),
        const SizedBox(width: 6),
        _roundButton(
          Icons.chevron_right_rounded,
          20,
          onNext,
          key: const ValueKey('date-popup-next'),
        ),
        const SizedBox(width: 6),
        _roundButton(
          Icons.calendar_today_outlined,
          17,
          onCalendar,
          key: const ValueKey('date-popup-calendar'),
        ),
      ],
    ),
  );
}

class _UsageChartCard extends StatelessWidget {
  const _UsageChartCard();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        'Data Penggunaan Obat',
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: Colors.black,
          height: 1,
          letterSpacing: -0.3,
        ),
      ),
      const SizedBox(height: 14),
      Container(
        height: 260,
        padding: const EdgeInsets.fromLTRB(16, 12, 12, 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 12,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: const Column(
          children: [
            Expanded(
              child: CustomPaint(
                size: Size.infinite,
                painter: _DashboardChartPainter(),
              ),
            ),
            SizedBox(height: 6),
            _DashboardChartLegend(),
          ],
        ),
      ),
    ],
  );
}

class _DashboardChartPainter extends CustomPainter {
  const _DashboardChartPainter();
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
        if (i == 0) {
          path.moveTo(point.dx, point.dy);
        } else {
          path.lineTo(point.dx, point.dy);
        }
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

class _DashboardChartLegend extends StatelessWidget {
  const _DashboardChartLegend();

  @override
  Widget build(BuildContext context) {
    const labels = [
      'Paracetamol',
      'Amoxicillin',
      'Omeprazole',
      'Cetirizine',
      'RingerLaktat',
    ];
    return FittedBox(
      fit: BoxFit.scaleDown,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(
          labels.length,
          (i) => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 11,
                height: 1.5,
                color: _DashboardChartPainter._colors[i],
              ),
              const SizedBox(width: 2),
              Text(
                labels[i],
                style: const TextStyle(fontSize: 6.8, color: Color(0xff4a4a4a)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
