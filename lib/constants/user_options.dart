/// Shared option lists and label helpers for user management.
library;

const roles = ['staff_divisi', 'kepala_divisi', 'kepala_rs', 'super_admin'];

const divisions = [
  'Rawat Inap',
  'Rawat Jalan',
  'UGD',
  'Apotek',
  'Kebidanan',
  'Pendaftaran',
];

/// Status values stored in the `status` field of a user document.
const statuses = ['aktif', 'nonaktif'];

String roleLabel(String role) => switch (role) {
  'staff_divisi' => 'Staff Divisi',
  'kepala_divisi' => 'Kepala Divisi',
  'kepala_rs' => 'Kepala Rumah Sakit',
  'super_admin' => 'Super Admin',
  _ => role,
};

/// Short label used in compact contexts such as the user table.
String roleShortLabel(String role) => switch (role) {
  'staff_divisi' => 'Staff',
  'kepala_divisi' => 'Kepala Divisi',
  'kepala_rs' => 'Kepala Rumah Sakit',
  'super_admin' => 'Super Admin',
  _ => role,
};

String statusLabel(String status) =>
    status == 'nonaktif' ? 'Nonaktif' : 'Aktif';

/// Normalizes a raw `status` value; null/unknown is treated as 'aktif'.
String normalizeStatus(Object? raw) =>
    raw?.toString().trim().toLowerCase() == 'nonaktif' ? 'nonaktif' : 'aktif';

/// Extracts a display name from a user map, falling back to email prefix.
String extractUserName(Map<String, dynamic> data) {
  final raw = (data['name'] ?? data['nama'] ?? data['username'])
      ?.toString()
      .trim();
  if (raw != null && raw.isNotEmpty) return raw;
  final email = extractUserEmail(data);
  if (email.isNotEmpty) return email.split('@').first;
  return '';
}

/// Extracts an email string from a user map.
String extractUserEmail(Map<String, dynamic> data) {
  return (data['email'] ?? '').toString().trim();
}

/// Extracts a division from a user map, returning null if empty or '-'.
String? extractUserDivision(Map<String, dynamic> data) {
  final raw = (data['division'] ?? data['divisi'])?.toString().trim();
  if (raw == null || raw.isEmpty || raw == '-') return null;
  return raw;
}

/// Extracts and normalizes the role from a user map.
String extractUserRole(Map<String, dynamic> data) {
  final raw = (data['role'] ?? data['peran'])?.toString().trim().toLowerCase();
  if (raw == null || raw.isEmpty) return 'staff_divisi';
  return switch (raw) {
    'staff' || 'staff divisi' || 'staff_divisi' => 'staff_divisi',
    'kepala divisi' || 'kadiv' || 'kepala_divisi' => 'kepala_divisi',
    'kepala rumah sakit' ||
    'kepala rs' ||
    'karumkit' ||
    'kars' ||
    'kepala_rs' =>
      'kepala_rs',
    'super admin' || 'admin' || 'super_admin' || 'superadmin' => 'super_admin',
    _ => raw,
  };
}
