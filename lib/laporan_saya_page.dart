import 'package:flutter/material.dart';

import 'constants/app_colors.dart';
import 'input_laporan_page.dart';

class _LaporanItem {
  final String title;
  final String subtitle;
  final bool accepted;
  final String description;

  const _LaporanItem({
    required this.title,
    required this.subtitle,
    required this.accepted,
    this.description = '',
  });
}

class LaporanSayaPage extends StatefulWidget {
  const LaporanSayaPage({super.key});

  @override
  State<LaporanSayaPage> createState() => _LaporanSayaPageState();
}

class _LaporanSayaPageState extends State<LaporanSayaPage> {
  static const String _rejectDesc =
      'Lorem Ipsum is simply dummy text of the printing and typesetting industry. '
      'Lorem Ipsum has been the industry\'s standard dummy text ever since the 1500s, '
      'when an unknown printer took a galley of type and scrambled it to make a type '
      'specimen book. It has survived not only five centuries, but also the leap into '
      'electronic typesetting, remaining essentially unchanged. It was popularised in '
      'the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, '
      'and more recently with desktop publishing software like Aldus PageMaker '
      'including versions of Lorem Ipsum.';

  static const List<_LaporanItem> _items = [
    _LaporanItem(
      title: 'Laporan X.X.X.X.X.X',
      subtitle: 'example......',
      accepted: true,
    ),
    _LaporanItem(
      title: 'Laporan X.X.X.X.X.X',
      subtitle: 'example......',
      accepted: false,
      description: _rejectDesc,
    ),
    _LaporanItem(
      title: 'Laporan X.X.X.X.X.X',
      subtitle: 'example......',
      accepted: true,
    ),
    _LaporanItem(
      title: 'Laporan X.X.X.X.X.X',
      subtitle: 'example......',
      accepted: false,
      description: _rejectDesc,
    ),
    _LaporanItem(
      title: 'Laporan X.X.X.X.X.X',
      subtitle: 'example......',
      accepted: false,
      description: _rejectDesc,
    ),
    _LaporanItem(
      title: 'Laporan X.X.X.X.X.X',
      subtitle: 'example......',
      accepted: false,
      description: _rejectDesc,
    ),
    _LaporanItem(
      title: 'Laporan X.X.X.X.X.X',
      subtitle: 'example......',
      accepted: true,
    ),
    _LaporanItem(
      title: 'Laporan X.X.X.X.X.X',
      subtitle: 'example......',
      accepted: true,
    ),
    _LaporanItem(
      title: 'Laporan X.X.X.X.X.X',
      subtitle: 'example......',
      accepted: true,
    ),
    _LaporanItem(
      title: 'Laporan X.X.X.X.X.X',
      subtitle: 'example......',
      accepted: true,
    ),
    _LaporanItem(
      title: 'Laporan X.X.X.X.X.X',
      subtitle: 'example......',
      accepted: true,
    ),
    _LaporanItem(
      title: 'Laporan X.X.X.X.X.X',
      subtitle: 'example......',
      accepted: true,
    ),
    _LaporanItem(
      title: 'Laporan X.X.X.X.X.X',
      subtitle: 'example......',
      accepted: true,
    ),
    _LaporanItem(
      title: 'Laporan X.X.X.X.X.X',
      subtitle: 'example......',
      accepted: true,
    ),
  ];

  // Index of rejected items whose description is expanded by default.
  final Set<int> _expanded = {1};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGray,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(),
                const SizedBox(height: 12),
                _buildSearchBar(),
                const SizedBox(height: 12),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 90),
                    child: Column(
                      children: List.generate(_items.length, (i) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildCard(i),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
            // Floating Input Laporan button
            Positioned(left: 12, bottom: 24, child: _buildInputLaporanButton()),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      height: 66,
      color: AppColors.white,
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
                  color: AppColors.black,
                ),
              ),
            ),
          ),
          const Text(
            'Laporan Saya',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1,
              letterSpacing: -0.4,
              color: AppColors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: Container(
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: const [
            BoxShadow(
              color: Color(0x42000000),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(21),
                ),
                child: const TextField(
                  decoration: InputDecoration(
                    icon: Icon(
                      Icons.search_rounded,
                      color: AppColors.black,
                      size: 23,
                    ),
                    hintText: 'Cari',
                    hintStyle: TextStyle(
                      fontSize: 16,
                      color: Color(0x80000000),
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  maxLines: 1,
                  textInputAction: TextInputAction.search,
                ),
              ),
            ),
            const SizedBox(width: 11),
            Container(
              height: 40,
              width: 97,
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(21),
                border: Border.all(
                  color: AppColors.innerBorderGray,
                  width: 1.5,
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x35000000),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.filter_alt_outlined,
                    color: AppColors.black,
                    size: 22,
                  ),
                  SizedBox(width: 5),
                  Flexible(
                    child: Text(
                      'Filter',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(int index) {
    final item = _items[index];
    final isExpanded = _expanded.contains(index);

    return GestureDetector(
      onTap: () {
        if (!item.accepted) {
          setState(() {
            if (isExpanded) {
              _expanded.remove(index);
            } else {
              _expanded.add(index);
            }
          });
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Color(0x2E000000),
              blurRadius: 10,
              spreadRadius: 1,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.black,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: AppColors.buttonIconGray,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                _StatusBadge(accepted: item.accepted),
              ],
            ),
            if (!item.accepted &&
                isExpanded &&
                item.description.isNotEmpty) ...[
              const SizedBox(height: 10),
              Text(
                item.description,
                style: const TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w400,
                  color: AppColors.buttonIconGray,
                  height: 1.35,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInputLaporanButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const InputLaporanPage()),
        );
      },
      child: Container(
        height: 46,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(23),
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.chevron_left, color: AppColors.black, size: 22),
            SizedBox(width: 4),
            Text(
              'Input Laporan',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final bool accepted;

  const _StatusBadge({required this.accepted});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: accepted ? AppColors.statusGreen : AppColors.statusRed,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(
            color: Color(0x2E000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Icon(
        accepted ? Icons.check_rounded : Icons.close_rounded,
        color: AppColors.white,
        size: 24,
      ),
    );
  }
}
