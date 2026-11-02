import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import 'tinjau_button.dart';

/// Floating pill with a single "Tinjau" button, used by reviewer roles.
class ReviewBar extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final Key? buttonKey;

  const ReviewBar({
    super.key,
    required this.onTap,
    this.label = 'Tinjau Laporan Masuk',
    this.buttonKey,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(44, 0, 44, 18),
      child: Container(
        height: 68,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(34),
          border: Border.all(color: AppColors.borderGray, width: 2),
          boxShadow: const [
            BoxShadow(
              color: Color(0x32000000),
              blurRadius: 9,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TinjauButton(key: buttonKey, label: label, onTap: onTap),
            ),
          ],
        ),
      ),
    );
  }
}
