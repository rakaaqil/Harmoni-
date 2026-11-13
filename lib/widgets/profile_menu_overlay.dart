import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class ProfileMenuOverlay extends StatelessWidget {
  final LayerLink profileLink;
  final VoidCallback onClose;
  final VoidCallback onChangePassword;
  final VoidCallback onLogout;

  const ProfileMenuOverlay({
    super.key,
    required this.profileLink,
    required this.onClose,
    required this.onChangePassword,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onClose,
          ),
        ),
        // Harus benar-benar "positioned" (punya edge) agar Stack ini tidak
        // menyusut ke ukuran menu; posisi visual ditentukan oleh follower.
        Positioned(
          top: 0,
          left: 0,
          child: CompositedTransformFollower(
            link: profileLink,
            targetAnchor: Alignment.bottomRight,
            followerAnchor: Alignment.topRight,
            offset: const Offset(0, 4),
            showWhenUnlinked: false,
            child: Container(
              width: 168,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                  profileAction(
                    key: const ValueKey('profile-menu-change-password'),
                    label: 'Ganti Password',
                    onTap: onChangePassword,
                  ),
                  const SizedBox(height: 8),
                  profileAction(
                    key: const ValueKey('profile-menu-logout'),
                    label: 'KELUAR',
                    labelColor: AppColors.logoutRed,
                    onTap: onLogout,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  static Widget profileAction({
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
}
