import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class PagerDots extends StatelessWidget {
  final int active;
  final int count;
  const PagerDots({super.key, required this.active, this.count = 6});
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
        count,
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
