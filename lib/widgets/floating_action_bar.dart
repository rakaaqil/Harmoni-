import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class FloatingActionBar extends StatelessWidget {
  final VoidCallback? onInputLaporan;
  final VoidCallback? onLaporanSaya;
  final VoidCallback? onLogout;

  const FloatingActionBar({
    super.key,
    this.onInputLaporan,
    this.onLaporanSaya,
    this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 18),
      child: Row(
        children: [
          // Main Button Capsule (Input Laporan & Laporan Saya)
          Expanded(
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: AppColors.borderGray, width: 2),
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
                  Expanded(
                    child: _InnerStadiumButton(
                      label: 'Input Laporan',
                      onTap: onInputLaporan ?? () {},
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _InnerStadiumButton(
                      label: 'Laporan Saya',
                      onTap: onLaporanSaya ?? () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 10),
          // Logout Button Container
          Container(
            width: 58,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.borderGray, width: 2),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x26000000),
                  blurRadius: 8,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(24),
                onTap: onLogout ?? () {},
                child: const Center(
                  child: Icon(
                    Icons.logout_rounded,
                    color: AppColors.logoutRed,
                    size: 28,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InnerStadiumButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _InnerStadiumButton({
    required this.label,
    required this.onTap,
  });

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
