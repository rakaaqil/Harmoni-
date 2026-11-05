import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/user_options.dart';

/// Called whenever the role/division/status filter changes (null = all).
typedef AdminFilterChanged = void Function(
  String? role,
  String? division,
  String? status,
);

/// Shows the Role/Division/Status filter bottom sheet.
void showAdminFilterSheet({
  required BuildContext context,
  required String? role,
  required String? division,
  String? status,
  required AdminFilterChanged onChanged,
}) {
  String? currentRole = role;
  String? currentDivision = division;
  String? currentStatus = status;

  showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (sheetContext) => StatefulBuilder(
      builder: (sheetContext, setSheetState) {
        void update(String? r, String? d, String? s) {
          setSheetState(() {
            currentRole = r;
            currentDivision = d;
            currentStatus = s;
          });
          onChanged(r, d, s);
        }

        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Filter',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                  TextButton(
                    key: const ValueKey('admin-filter-reset'),
                    onPressed: () => update(null, null, null),
                    child: const Text(
                      'Reset',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.teal,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text(
                'Role',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              _dropdown(
                key: const ValueKey('admin-filter-role'),
                value: currentRole,
                allLabel: 'Semua Role',
                items: {for (final r in roles) r: roleLabel(r)},
                onChanged: (v) => update(v, currentDivision, currentStatus),
              ),
              const SizedBox(height: 12),
              const Text(
                'Divisi',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              _dropdown(
                key: const ValueKey('admin-filter-division'),
                value: currentDivision,
                allLabel: 'Semua Divisi',
                items: {for (final d in divisions) d: d},
                onChanged: (v) => update(currentRole, v, currentStatus),
              ),
              const SizedBox(height: 12),
              const Text(
                'Status',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
              ),
              _dropdown(
                key: const ValueKey('admin-filter-status'),
                value: currentStatus,
                allLabel: 'Semua Status',
                items: {for (final s in statuses) s: statusLabel(s)},
                onChanged: (v) => update(currentRole, currentDivision, v),
              ),
            ],
          ),
        );
      },
    ),
  );
}

Widget _dropdown({
  required Key key,
  required String? value,
  required String allLabel,
  required Map<String, String> items,
  required ValueChanged<String?> onChanged,
}) => SizedBox(
  height: 44,
  child: DropdownButtonHideUnderline(
    child: DropdownButton<String?>(
      key: key,
      value: value,
      isExpanded: true,
      hint: Text(allLabel),
      items: [
        DropdownMenuItem<String?>(value: null, child: Text(allLabel)),
        ...items.entries.map(
          (e) => DropdownMenuItem<String?>(value: e.key, child: Text(e.value)),
        ),
      ],
      onChanged: onChanged,
    ),
  ),
);
