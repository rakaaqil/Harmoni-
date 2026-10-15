import 'package:flutter/material.dart';
import 'dashboard_page.dart';

const _ink = Color(0xFF000000);
const _teal = Color(0xFF12B5AE);
const _inputBg = Color(0xFFD9D9D9);
const _placeholderGray = Color(0xFF6B6B6B);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
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
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const DashboardPage()),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _teal,
                                    foregroundColor: _ink,
                                    elevation: 4,
                                    shadowColor: const Color(0x55000000),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(19),
                                    ),
                                  ),
                                  child: const Text(
                                    'MASUK',
                                    style: TextStyle(
                                      fontSize: 23,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ),
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
