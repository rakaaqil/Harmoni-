import 'package:flutter/material.dart';

import 'panel_card.dart';

class ChartCard extends StatelessWidget {
  final VoidCallback onTap;
  const ChartCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) => PanelCard(
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
            child: CustomPaint(size: Size.infinite, painter: ChartPainter()),
          ),
          const SizedBox(height: 5),
          const ChartLegend(),
        ],
      ),
    ),
  );
}

class ChartPainter extends CustomPainter {
  static const colors = [
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
          ..color = colors[series]
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
            ..color = colors[series]
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

class ChartLegend extends StatelessWidget {
  const ChartLegend({super.key});
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
                color: ChartPainter.colors[i],
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
