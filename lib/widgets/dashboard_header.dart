import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class DashboardHeader extends StatelessWidget {
  final VoidCallback? onProfileTap;
  final LayerLink? profileLink;
  final String name;
  final String? division;

  const DashboardHeader({
    super.key,
    this.onProfileTap,
    this.profileLink,
    this.name = 'Budiono Siregar',
    this.division,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Image.asset(
            'assets/images/logo.png',
            width: 48,
            height: 48,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.local_hospital_rounded,
              color: AppColors.teal,
              size: 42,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                const FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Selamat Datang Kembali',
                    maxLines: 1,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                      color: AppColors.black,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                const SizedBox(height: 1),
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
                if (division != null)
                  Text(
                    division!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: AppColors.black,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          CompositedTransformTarget(
            link: profileLink ?? LayerLink(),
            child: GestureDetector(
              key: const ValueKey('profile-button'),
              onTap: onProfileTap,
              child: Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColors.avatarGray,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.person_outline_rounded,
                  size: 34,
                  color: AppColors.avatarIconGray,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
