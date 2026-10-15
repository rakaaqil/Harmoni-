import 'package:flutter/material.dart';

// --- PALET WARNA MINIMALIS ---
const Color _kBackground = Color(0xFFFFFFFF);
const Color _kPrimaryText = Color(0xFF1A1A1A);
const Color _kSecondaryText = Color(0xFF777777);
const Color _kBorder = Color(0xFFD9D9D9);
const Color _kSecondaryBg = Color(0xFFF7F7F7);
const Color _kInactive = Color(0xFFB0B0B0);

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBackground,
      body: Column(
        children: [
          const _HeaderWidget(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ringkasan Laporan Bulan Ini',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _kPrimaryText,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Row(
                    children: [
                      Expanded(child: _SummaryCard(label: 'Total Laporan', value: '12')),
                      SizedBox(width: 8),
                      Expanded(child: _SummaryCard(label: 'Review', value: '3')),
                      SizedBox(width: 8),
                      Expanded(child: _SummaryCard(label: 'Disetujui', value: '9')),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Pelaporan Cepat',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: _kPrimaryText,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _QuickActionButton(
                    icon: Icons.add,
                    label: 'Buat Laporan Baru',
                    isPrimary: true,
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _QuickActionButton(
                    icon: Icons.folder_open,
                    label: 'Riwayat Laporan',
                    isPrimary: false,
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _BottomNavigation(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}

// --- HEADER ---
class _HeaderWidget extends StatelessWidget {
  const _HeaderWidget();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _kSecondaryBg,
        border: Border(bottom: BorderSide(color: _kBorder, width: 0.8)),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: _kSecondaryBg,
                  shape: BoxShape.circle,
                  border: Border.all(color: _kBorder),
                ),
                child: const Text(
                  'S',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _kSecondaryText,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selamat Datang, Budi',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: _kPrimaryText,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Staff Pelaksana',
                      style: TextStyle(fontSize: 11, color: _kSecondaryText),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Material(
                color: _kBackground,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: _kBorder),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  onTap: () {},
                  child: const SizedBox(
                    width: 36,
                    height: 36,
                    child: Icon(
                      Icons.notifications_none,
                      size: 18,
                      color: _kPrimaryText,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- CARD RINGKASAN ---
class _SummaryCard extends StatelessWidget {
  final String label;
  final String value;

  const _SummaryCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: _kBackground,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _kBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 10.5, color: _kSecondaryText),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: _kPrimaryText,
            ),
          ),
        ],
      ),
    );
  }
}

// --- TOMBOL AKSI CEPAT ---
class _QuickActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isPrimary;
  final VoidCallback onTap;

  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.isPrimary,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color fg = isPrimary ? Colors.white : _kPrimaryText;

    return Material(
      color: isPrimary ? _kPrimaryText : _kBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(color: isPrimary ? _kPrimaryText : _kBorder),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onTap,
        child: Container(
          height: 46,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Icon(icon, size: 18, color: fg),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: fg,
                  ),
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 12, color: fg),
            ],
          ),
        ),
      ),
    );
  }
}

// --- BOTTOM NAVIGATION ---
class _BottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNavigation({required this.currentIndex, required this.onTap});

  static const List<_NavItem> _items = [
    _NavItem('Beranda', Icons.home_outlined, Icons.home),
    _NavItem('Rekap', Icons.receipt_long_outlined, Icons.receipt_long),
    _NavItem('Laporan', Icons.folder_outlined, Icons.folder),
    _NavItem('Profil', Icons.person_outline, Icons.person),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _kBackground,
        border: Border(top: BorderSide(color: _kBorder, width: 0.8)),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 60,
          child: Row(
            children: List.generate(_items.length, (i) {
              final item = _items[i];
              final active = i == currentIndex;
              final color = active ? _kPrimaryText : _kInactive;

              return Expanded(
                child: InkWell(
                  onTap: () => onTap(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(active ? item.activeIcon : item.icon,
                          size: 22, color: color),
                      const SizedBox(height: 3),
                      Text(
                        item.label,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: active ? FontWeight.bold : FontWeight.normal,
                          color: color,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const _NavItem(this.label, this.icon, this.activeIcon);
}