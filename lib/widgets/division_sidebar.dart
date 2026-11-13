import 'package:flutter/material.dart';

const kHospitalDivisions = [
  'Divisi Apotek',
  'Divisi Kebidanan',
  'Divisi Pendaftaran',
  'Divisi Rawat Inap',
  'Divisi Rawat Jalan',
  'Divisi UGD',
];

class DivisionSidebar extends StatelessWidget {
  final List<String> divisions;
  final String selectedDivision;
  final ValueChanged<String> onSelect;
  final String keyPrefix;

  const DivisionSidebar({
    super.key,
    this.divisions = kHospitalDivisions,
    required this.selectedDivision,
    required this.onSelect,
    this.keyPrefix = 'division',
  });

  @override
  Widget build(BuildContext context) => Material(
    color: Colors.white,
    elevation: 8,
    child: SizedBox(
      width: 228,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(19, 12, 25, 0),
          child: ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: divisions.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              final division = divisions[index];
              final selected = division == selectedDivision;
              return Material(
                color: selected
                    ? const Color(0xFF16B5AE)
                    : const Color(0xFFD9D9D9),
                borderRadius: BorderRadius.circular(14),
                child: InkWell(
                  key: ValueKey('$keyPrefix-$division'),
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => onSelect(division),
                  child: Container(
                    height: 28,
                    alignment: Alignment.center,
                    child: Text(
                      division,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    ),
  );
}
