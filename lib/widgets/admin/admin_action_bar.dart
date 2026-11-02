import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

/// Bottom bar with the "Edit Pengguna" and "Tambah Pengguna" buttons.
class AdminActionBar extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onAdd;

  const AdminActionBar({super.key, required this.onEdit, required this.onAdd});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
    child: Row(
      children: [
        Expanded(
          child: _ActionButton(
            key: const ValueKey('admin-edit'),
            label: 'Edit Pengguna',
            icon: Icons.edit_outlined,
            iconOnLeft: true,
            onTap: onEdit,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionButton(
            key: const ValueKey('admin-add'),
            label: 'Tambah Pengguna',
            icon: Icons.add,
            iconOnLeft: false,
            onTap: onAdd,
          ),
        ),
      ],
    ),
  );
}

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool iconOnLeft;
  final VoidCallback onTap;

  const _ActionButton({
    super.key,
    required this.label,
    required this.icon,
    required this.iconOnLeft,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final circle = Container(
      width: 48,
      height: 48,
      decoration: const BoxDecoration(
        color: Color(0xFF12B5AE),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: AppColors.black, size: 24),
    );
    final text = Expanded(
      child: Text(
        label,
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          height: 1.1,
          color: AppColors.black,
        ),
      ),
    );

    return Container(
      height: 62,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: const Color(0xFFD0D0D0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40000000),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(34),
        child: InkWell(
          borderRadius: BorderRadius.circular(34),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 7),
            child: Row(
              children: iconOnLeft
                  ? [circle, const SizedBox(width: 6), text, const SizedBox(width: 6)]
                  : [const SizedBox(width: 6), text, const SizedBox(width: 6), circle],
            ),
          ),
        ),
      ),
    );
  }
}
