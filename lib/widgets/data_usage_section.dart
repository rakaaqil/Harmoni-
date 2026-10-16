import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import '../models/dashboard_data_model.dart';

class DataUsageSection extends StatelessWidget {
  final List<MedicineStock> data;
  final VoidCallback onSeeAll;

  const DataUsageSection({
    super.key,
    required this.data,
    required this.onSeeAll,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(),
          _buildTable(),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.teal,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.add_circle_outline,
            color: AppColors.white,
            size: 20,
          ),
          SizedBox(width: 8),
          Text(
            'Data Penggunaan Obat',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.white,
              letterSpacing: -0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTable() {
    return Column(
      children: [
        _buildTableHeader(),
        ...data.asMap().entries.map((entry) {
          return _buildTableRow(
            entry.value,
            entry.key % 2 == 1,
          );
        }),
      ],
    );
  }

  Widget _buildTableHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.borderGray,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: _buildHeaderText('No'),
          ),
          Expanded(
            flex: 4,
            child: _buildHeaderText('Nama obat'),
          ),
          Expanded(
            flex: 3,
            child: _buildHeaderText('Satuan'),
          ),
          SizedBox(
            width: 56,
            child: _buildHeaderText('Jumlah', align: TextAlign.right),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderText(String text, {TextAlign align = TextAlign.left}) {
    return Text(
      text,
      textAlign: align,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w700,
        color: AppColors.black,
        letterSpacing: -0.2,
      ),
    );
  }

  Widget _buildTableRow(MedicineStock item, bool isGray) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isGray ? AppColors.rowGray : AppColors.white,
        border: const Border(
          bottom: BorderSide(
            color: AppColors.borderGray,
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 32,
            child: _buildCellText(item.no),
          ),
          Expanded(
            flex: 4,
            child: _buildCellText(item.name),
          ),
          Expanded(
            flex: 3,
            child: _buildCellText(item.unit),
          ),
          SizedBox(
            width: 56,
            child: _buildCellText(item.quantity, align: TextAlign.right),
          ),
        ],
      ),
    );
  }

  Widget _buildCellText(String text, {TextAlign align = TextAlign.left}) {
    return Text(
      text,
      textAlign: align,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: AppColors.black,
        letterSpacing: -0.1,
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total 8558 items',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.black,
              letterSpacing: -0.1,
            ),
          ),
          GestureDetector(
            onTap: onSeeAll,
            child: const Row(
              children: [
                Text(
                  'Lihat Semua',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.teal,
                    letterSpacing: -0.1,
                  ),
                ),
                SizedBox(width: 4),
                Icon(
                  Icons.chevron_right,
                  color: AppColors.teal,
                  size: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
