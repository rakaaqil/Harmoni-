import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class TinjauButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const TinjauButton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.innerBorderGray, width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                color: AppColors.black,
                letterSpacing: -0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
