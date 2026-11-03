import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'admin_data_pengguna_page.dart';
import 'constants/user_options.dart';
import 'kepala_divisi_dashboard_page.dart';
import 'kepala_rs_dashboard_page.dart';
import 'models/user_profile.dart';
import 'staff_dashboard_page.dart';

const _ink = Color(0xFF000000);
const _teal = Color(0xFF12B5AE);
const _inputBg = Color(0xFFD9D9D9);
const _placeholderGray = Color(0xFF6B6B6B);

/// Halaman login dengan validasi autentikasi dan status aktif pengguna.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Email dan kata sandi harus diisi');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      String authEmail = email;
      Map<String, dynamic>? preloadedData;

      // Jika user mengetik nama pengguna (tanpa '@'), cari email-nya di Firestore terlebih dahulu
      if (!email.contains('@')) {
        try {
          preloadedData = await _fetchProfileData(null, email);
          final foundEmail = preloadedData?['email']?.toString().trim();
          if (foundEmail != null && foundEmail.contains('@')) {
            authEmail = foundEmail;
          }
        } catch (e) {
          debugPrint('Lookup username sebelum auth gagal: $e');
        }
      }

      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: authEmail, password: password);

      Map<String, dynamic>? data = preloadedData;
      if (data == null) {
        try {
          data = await _fetchProfileData(credential.user, authEmail);
        } catch (e) {
          debugPrint('Firestore lookup warning saat login: $e');
        }
      }

      if (normalizeStatus(data?['status']) == 'nonaktif') {
        await FirebaseAuth.instance.signOut();
        if (!mounted) return;
        setState(() {
          _isLoading = false;
          _errorMessage = 'Akun pengguna dinonaktifkan';
        });
        return;
      }

      if (!mounted) return;

      final profile = _buildProfile(
        data: data,
        user: credential.user,
        inputEmail: authEmail,
      );

      final Widget destination;
      if (profile.isSuperAdmin) {
        destination = const AdminDataPenggunaPage();
      } else if (profile.role == 'kepala_rs') {
        destination = KepalaRsDashboardPage(profile: profile);
      } else if (profile.role == 'kepala_divisi') {
        destination = KepalaDivisiDashboardPage(profile: profile);
      } else {
        destination = StaffDashboardPage(profile: profile);
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => destination),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;
      final message = switch (e.code) {
        'wrong-password' => 'Kata sandi salah',
        'user-not-found' => 'Pengguna tidak ditemukan',
        'invalid-email' => 'Format email tidak valid',
        'invalid-credential' => 'Email atau kata sandi salah',
        'user-disabled' => 'Akun pengguna dinonaktifkan',
        'too-many-requests' => 'Terlalu banyak percobaan, coba lagi nanti',
        'network-request-failed' => 'Koneksi jaringan bermasalah',
        _ => 'Terjadi kesalahan, coba lagi',
      };
      setState(() {
        _isLoading = false;
        _errorMessage = message;
      });
    } catch (e) {
      debugPrint('Error saat login: $e');
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Terjadi kesalahan, coba lagi';
      });
    }
  }

  Future<Map<String, dynamic>?> _fetchProfileData(
    User? user,
    String email,
  ) async {
    final users = FirebaseFirestore.instance.collection('users');
    final uid = user?.uid;

    if (uid != null && uid.isNotEmpty) {
      final byUid = await users.doc(uid).get();
      if (byUid.exists && byUid.data() != null) return byUid.data();
    }

    final exactSnap = await users.where('email', isEqualTo: email).limit(1).get();
    if (exactSnap.docs.isNotEmpty) return exactSnap.docs.first.data();

    final lowerEmail = email.toLowerCase();
    if (lowerEmail != email) {
      final lowerSnap = await users
          .where('email', isEqualTo: lowerEmail)
          .limit(1)
          .get();
      if (lowerSnap.docs.isNotEmpty) return lowerSnap.docs.first.data();
    }

    final allSnap = await users.get();
    for (final doc in allSnap.docs) {
      final d = doc.data();
      final docEmail = d['email']?.toString().trim().toLowerCase();
      final docName = d['name']?.toString().trim().toLowerCase();
      final docUsername = d['username']?.toString().trim().toLowerCase();
      if (docEmail == lowerEmail ||
          docName == lowerEmail ||
          docUsername == lowerEmail) {
        return d;
      }
    }
    return null;
  }

  UserProfile _buildProfile({
    required Map<String, dynamic>? data,
    required User? user,
    required String inputEmail,
  }) {
    final effectiveEmail =
        (data?['email'] ?? user?.email ?? inputEmail).toString().trim();
    final emailPrefix = effectiveEmail.split('@').first;
    final rawName = (data?['name'] ??
            data?['nama'] ??
            data?['username'] ??
            user?.displayName ??
            emailPrefix)
        .toString()
        .trim();
    final rawDivision =
        (data?['division'] ?? data?['divisi'])?.toString().trim();

    final rawRoleFromDoc = (data?['role'] ?? data?['peran'])
        ?.toString()
        .trim()
        .toLowerCase();
    final String normalizedRole;
    if (rawRoleFromDoc != null && rawRoleFromDoc.isNotEmpty) {
      normalizedRole = switch (rawRoleFromDoc) {
        'super_admin' || 'super admin' || 'admin' || 'superadmin' =>
          'super_admin',
        'kepala_rs' ||
        'kepala rumah sakit' ||
        'kepala rs' ||
        'kars' ||
        'karumkit' =>
          'kepala_rs',
        'kepala_divisi' || 'kepala divisi' || 'kadiv' => 'kepala_divisi',
        _ => 'staff_divisi',
      };
    } else {
      final lowerPrefix = emailPrefix.toLowerCase();
      if (lowerPrefix.contains('admin')) {
        normalizedRole = 'super_admin';
      } else if (lowerPrefix.contains('kadiv') ||
          lowerPrefix.contains('kepala_divisi')) {
        normalizedRole = 'kepala_divisi';
      } else if (lowerPrefix.contains('kars') ||
          lowerPrefix.contains('karumkit') ||
          lowerPrefix.contains('kepala_rs') ||
          lowerPrefix == 'rs') {
        normalizedRole = 'kepala_rs';
      } else {
        normalizedRole = 'staff_divisi';
      }
    }

    return UserProfile(
      email: effectiveEmail.isEmpty ? inputEmail : effectiveEmail,
      name: rawName.isEmpty ? emailPrefix : rawName,
      role: normalizedRole,
      division: (rawDivision == null || rawDivision.isEmpty)
          ? null
          : rawDivision,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 88, 24, 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/harmoni_logo.png',
                        width: 288,
                        height: 77,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        'Pelaporan Cerdas, Pelayanan Berkualitas',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          height: 1.15,
                          color: _ink,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 40),
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 342),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(36, 34, 36, 34),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(21),
                            boxShadow: const [
                              BoxShadow(
                                color: Color(0x40000000),
                                blurRadius: 14,
                                offset: Offset(0, 7),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'MASUK',
                                style: TextStyle(
                                  fontSize: 23,
                                  height: 1,
                                  fontWeight: FontWeight.w900,
                                  color: _ink,
                                ),
                              ),
                              const SizedBox(height: 44),
                              _LoginField(
                                controller: _usernameController,
                                hintText: 'Nama Pengguna',
                              ),
                              const SizedBox(height: 26),
                              _LoginField(
                                controller: _passwordController,
                                hintText: 'Kata Sandi',
                                obscureText: true,
                              ),
                              const SizedBox(height: 33),
                              SizedBox(
                                width: double.infinity,
                                height: 59,
                                child: ElevatedButton(
                                  onPressed: _isLoading ? null : _handleLogin,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _teal,
                                    foregroundColor: _ink,
                                    disabledBackgroundColor:
                                        _teal.withValues(alpha: 0.6),
                                    elevation: 4,
                                    shadowColor: const Color(0x55000000),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(19),
                                    ),
                                  ),
                                  child: _isLoading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2.5,
                                            color: _ink,
                                          ),
                                        )
                                      : const Text(
                                          'MASUK',
                                          style: TextStyle(
                                            fontSize: 23,
                                            fontWeight: FontWeight.w900,
                                          ),
                                        ),
                                ),
                              ),
                              if (_errorMessage != null) ...[
                                const SizedBox(height: 16),
                                Text(
                                  _errorMessage!,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _LoginField extends StatelessWidget {
  const _LoginField({
    required this.controller,
    required this.hintText,
    this.obscureText = false,
  });

  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            fontSize: 16,
            color: _placeholderGray,
            fontWeight: FontWeight.w700,
          ),
          filled: true,
          fillColor: _inputBg,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(19),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 17),
        ),
        style: const TextStyle(fontSize: 16, color: _ink),
      ),
    );
  }
}
