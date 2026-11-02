class UserProfile {
  final String email;
  final String name;
  final String role;
  final String? division;

  const UserProfile({
    required this.email,
    required this.name,
    required this.role,
    this.division,
  });

  static const _staffRole = 'staff_divisi';
  static const _headDivRole = 'kepala_divisi';
  static const _headRsRole = 'kepala_rs';
  static const _superAdminRole = 'super_admin';

  bool get isStaff => role == _staffRole;
  bool get isManager => role == _headDivRole || role == _headRsRole;
  bool get isSuperAdmin => role == _superAdminRole;

  /// Teks baris ketiga di header dashboard (sesuai desain).
  String? get headerLabel {
    final div = division?.trim();
    return switch (role) {
      _headRsRole => 'Kepala Rumah Sakit',
      _headDivRole => (div == null || div.isEmpty)
          ? 'Kepala Divisi'
          : (div.toLowerCase().startsWith('kepala divisi')
                ? div
                : 'Kepala Divisi $div'),
      _ => (div == null || div.isEmpty)
          ? null
          : (div.toLowerCase().startsWith('divisi') ? div : 'Divisi $div'),
    };
  }
}
