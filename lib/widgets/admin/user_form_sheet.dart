import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/user_options.dart';

/// Signature for persisting the add/edit user form.
typedef UserFormSave =
    Future<void> Function(
      String name,
      String email,
      String role,
      String? division,
      String status, [
      String? password,
    ]);

/// Shows the add/edit user bottom sheet.
///
/// [context] must belong to the page so the success SnackBar can be shown
/// after the sheet closes.
void showUserFormSheet({
  required BuildContext context,
  required String title,
  required UserFormSave onSave,
  bool isEdit = false,
  String initialName = '',
  String initialEmail = '',
  String initialRole = '',
  String? initialDivision,
  String initialStatus = 'aktif',
}) {
  final name = TextEditingController(text: initialName);
  final email = TextEditingController(text: initialEmail);
  final password = TextEditingController();
  String role = roles.contains(initialRole) ? initialRole : roles.first;
  String? division =
      (initialDivision != null && divisions.contains(initialDivision))
      ? initialDivision
      : 'Apotek';
  String status = normalizeStatus(initialStatus);

  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
    ),
    builder: (sheetContext) => Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 18),
            _field(
              key: const ValueKey('admin-name'),
              controller: name,
              hint: 'Nama',
            ),
            const SizedBox(height: 12),
            _field(
              key: const ValueKey('admin-email'),
              controller: email,
              hint: 'Email',
            ),
            const SizedBox(height: 12),
            _field(
              key: const ValueKey('admin-password'),
              controller: password,
              hint: isEdit ? 'Password Baru (opsional)' : 'Password',
              obscureText: true,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              key: const ValueKey('admin-division'),
              initialValue: divisions.contains(division) ? division : 'Apotek',
              decoration: _decoration('Divisi'),
              items: divisions
                  .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                  .toList(),
              onChanged: (v) => division = v,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              key: const ValueKey('admin-role'),
              initialValue: roles.contains(role) ? role : roles.first,
              decoration: _decoration('Role'),
              items: roles
                  .map(
                    (r) => DropdownMenuItem(value: r, child: Text(roleLabel(r))),
                  )
                  .toList(),
              onChanged: (v) => role = v ?? role,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      key: const ValueKey('admin-cancel'),
                      onPressed: () => Navigator.pop(sheetContext),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.black,
                        side: const BorderSide(color: Color(0xFFBDBDBD)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      key: const ValueKey('admin-save'),
                      onPressed: () async {
                        final trimmedName = name.text.trim();
                        final trimmedEmail = email.text.trim();
                        final trimmedPass = password.text.trim();
                        if (trimmedName.isEmpty ||
                            (!isEdit && trimmedEmail.isEmpty)) {
                          ScaffoldMessenger.of(sheetContext).showSnackBar(
                            const SnackBar(
                              content: Text('Nama dan email wajib diisi'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        Navigator.pop(sheetContext);
                        await onSave(
                          trimmedName,
                          trimmedEmail.isEmpty ? initialEmail : trimmedEmail,
                          role,
                          division,
                          status,
                          trimmedPass.isEmpty ? null : trimmedPass,
                        );
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Berhasil disimpan'),
                              backgroundColor: AppColors.teal,
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF12B5AE),
                        foregroundColor: Colors.black,
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        isEdit ? 'Ubah' : 'Tambah',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            if (isEdit) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  key: const ValueKey('admin-toggle-status'),
                  onPressed: () async {
                    final nextStatus = status == 'nonaktif'
                        ? 'aktif'
                        : 'nonaktif';
                    final trimmedName = name.text.trim();
                    final trimmedEmail = email.text.trim();
                    final trimmedPass = password.text.trim();
                    Navigator.pop(sheetContext);
                    await onSave(
                      trimmedName.isEmpty ? initialName : trimmedName,
                      trimmedEmail.isEmpty ? initialEmail : trimmedEmail,
                      role,
                      division,
                      nextStatus,
                      trimmedPass.isEmpty ? null : trimmedPass,
                    );
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            nextStatus == 'nonaktif'
                                ? 'Pengguna dinonaktifkan'
                                : 'Pengguna diaktifkan',
                          ),
                          backgroundColor: nextStatus == 'nonaktif'
                              ? AppColors.statusRed
                              : AppColors.teal,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: status == 'nonaktif'
                        ? const Color(0xFF12B5AE)
                        : AppColors.statusRed,
                    foregroundColor: status == 'nonaktif'
                        ? Colors.black
                        : Colors.white,
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: Text(
                    status == 'nonaktif' ? 'Aktifkan' : 'Nonaktifkan',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    ),
  );
}

Widget _field({
  required Key key,
  required TextEditingController controller,
  required String hint,
  bool obscureText = false,
}) => SizedBox(
  height: 50,
  child: TextField(
    key: key,
    controller: controller,
    obscureText: obscureText,
    decoration: _decoration(hint),
  ),
);

InputDecoration _decoration(String hint) => InputDecoration(
  hintText: hint,
  hintStyle: const TextStyle(fontSize: 14, color: Color(0xFF6B6B6B)),
  filled: true,
  fillColor: const Color(0xFFF0F0F0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(13),
    borderSide: BorderSide.none,
  ),
  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
);
