import 'package:flutter/material.dart';

import 'constants/app_colors.dart';
import 'login_page.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  static const _demoOldPassword = '123456';

  final _oldController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  @override
  void dispose() {
    _oldController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.white,
    body: SafeArea(
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: _buildFormCard(),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _buildHeader() => Container(
    width: double.infinity,
    height: 66,
    color: Colors.white,
    child: Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          left: 30,
          child: InkResponse(
            onTap: () => Navigator.pop(context),
            radius: 22,
            child: Container(
              width: 41,
              height: 41,
              decoration: const BoxDecoration(
                color: Color(0xFFD9D9D9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                size: 24,
                color: Color(0xFF1A1A1A),
              ),
            ),
          ),
        ),
        const Text(
          'Ganti Password',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            height: 1,
            letterSpacing: -0.4,
            color: Colors.black,
          ),
        ),
      ],
    ),
  );

  Widget _buildFormCard() => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 351),
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.fromLTRB(28, 22, 28, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(23),
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
            'Ganti Password',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 18),
          _passwordField(
            key: const ValueKey('change-password-old'),
            controller: _oldController,
            hintText: 'Password Lama',
          ),
          const SizedBox(height: 16),
          _passwordField(
            key: const ValueKey('change-password-new'),
            controller: _newController,
            hintText: 'Password Baru',
          ),
          const SizedBox(height: 16),
          _passwordField(
            key: const ValueKey('change-password-confirm'),
            controller: _confirmController,
            hintText: 'Konfirmasi Password Baru',
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              key: const ValueKey('change-password-submit'),
              onPressed: _submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.teal,
                foregroundColor: Colors.black,
                elevation: 4,
                shadowColor: const Color(0x55000000),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(19),
                ),
              ),
              child: const Text(
                'Lanjut',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
              ),
            ),
          ),
        ],
      ),
    ),
  );

  Widget _passwordField({
    required Key key,
    required TextEditingController controller,
    required String hintText,
  }) => SizedBox(
    key: key,
    height: 52,
    child: TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontSize: 16,
          color: Color(0xFF6B6B6B),
          fontWeight: FontWeight.w700,
        ),
        filled: true,
        fillColor: const Color(0xFFD9D9D9),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(19),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 17),
      ),
      style: const TextStyle(fontSize: 16, color: Colors.black),
    ),
  );

  void _submit() {
    final oldPassword = _oldController.text;
    final newPassword = _newController.text;
    final confirmation = _confirmController.text;

    if (oldPassword != _demoOldPassword) {
      _showError('Password lama salah');
      return;
    }
    if (newPassword.isEmpty) {
      _showError('Password baru tidak boleh kosong');
      return;
    }
    if (confirmation != newPassword) {
      _showError('Konfirmasi password tidak sama');
      return;
    }

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (route) => false,
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
