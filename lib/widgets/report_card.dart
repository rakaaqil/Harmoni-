import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'panel_card.dart';

class ReportCard extends StatelessWidget {
  final VoidCallback onTap;
  const ReportCard({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) => PanelCard(
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
