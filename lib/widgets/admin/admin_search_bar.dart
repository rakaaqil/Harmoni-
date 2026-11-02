import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';

/// White pill containing the search field and the "Filter" button.
class AdminSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final VoidCallback onFilter;

  /// Whether any filter is currently active (highlights the button).
  final bool filterActive;

  const AdminSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.onFilter,
    this.filterActive = false,
  });

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(30),
      boxShadow: const [
        BoxShadow(color: Color(0x33000000), blurRadius: 8, offset: Offset(0, 4)),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 40,
            child: TextField(
              key: const ValueKey('admin-search'),
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(fontSize: 14, color: AppColors.black),
              decoration: InputDecoration(
                hintText: 'Cari',
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF6B6B6B),
                ),
                filled: true,
                fillColor: const Color(0xFFD9D9D9),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 20,
                  color: Color(0xFF555555),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(22),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Material(
          color: AppColors.white,
          shape: StadiumBorder(
            side: BorderSide(
              color: filterActive ? AppColors.teal : const Color(0xFFE0E0E0),
            ),
          ),
          elevation: 2,
          child: InkWell(
            key: const ValueKey('admin-filter'),
            customBorder: const StadiumBorder(),
            onTap: onFilter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.filter_alt_outlined,
                    size: 20,
                    color: filterActive ? AppColors.teal : AppColors.black,
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Filter',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
