import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class DataCarouselCard extends StatelessWidget {
  final String cardTitle;
  final List<String> headers;
  final List<double?> columnWidths;
  final List<int> columnFlexes;
  final List<List<String>> rows;
  final int activeDotIndex;
  final int totalDots;
  final VoidCallback onPrev;
  final VoidCallback onNext;
  final VoidCallback? onCardTap;

  const DataCarouselCard({
    super.key,
    required this.cardTitle,
    required this.headers,
    required this.columnWidths,
    required this.columnFlexes,
    required this.rows,
    required this.activeDotIndex,
    required this.totalDots,
    required this.onPrev,
    required this.onNext,
    this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _CircularArrowButton(
                icon: Icons.chevron_left_rounded,
                onTap: onPrev,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: GestureDetector(
                  onTap: onCardTap,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x2E000000),
                          blurRadius: 18,
                          spreadRadius: 2,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 16, 14, 16),
                    child: Column(
                      children: [
                        Text(
                          cardTitle,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.black,
                            letterSpacing: -0.2,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Column(
                            children: [
                              // Table Header
                              Container(
                                color: AppColors.teal,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 8,
                                ),
                                child: Row(
                                  children: List.generate(headers.length, (i) {
                                    final child = Text(
                                      headers[i],
                                      textAlign: i == 0
                                          ? TextAlign.center
                                          : (i == headers.length - 1
                                              ? TextAlign.right
                                              : TextAlign.left),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.white,
                                      ),
                                    );
                                    if (columnWidths[i] != null) {
                                      return SizedBox(
                                        width: columnWidths[i],
                                        child: child,
                                      );
                                    }
                                    return Expanded(
                                      flex: columnFlexes[i],
                                      child: child,
                                    );
                                  }),
                                ),
                              ),
                              // Table Rows
                              ...rows.asMap().entries.map((entry) {
                                final rowIndex = entry.key;
                                final row = entry.value;
                                final isAlternate = rowIndex % 2 == 1;

                                return Container(
                                  color: isAlternate ? AppColors.rowGray : AppColors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 7,
                                  ),
                                  child: Row(
                                    children: List.generate(row.length, (i) {
                                      final child = Text(
                                        row[i],
                                        textAlign: i == 0
                                            ? TextAlign.center
                                            : (i == row.length - 1
                                                ? TextAlign.right
                                                : TextAlign.left),
                                        style: const TextStyle(
                                          fontSize: 11.5,
                                          color: AppColors.black,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      );
                                      if (columnWidths[i] != null) {
                                        return SizedBox(
                                          width: columnWidths[i],
                                          child: child,
                                        );
                                      }
                                      return Expanded(
                                        flex: columnFlexes[i],
                                        child: child,
                                      );
                                    }),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              ),
              const SizedBox(width: 4),
              _CircularArrowButton(
                icon: Icons.chevron_right_rounded,
                onTap: onNext,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _PageDotIndicator(
          totalDots: totalDots,
          activeIndex: activeDotIndex,
        ),
      ],
    );
  }
}

class _CircularArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircularArrowButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30,
        height: 30,
        decoration: const BoxDecoration(
          color: AppColors.circularButtonGray,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Color(0x2E000000),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Icon(
          icon,
          size: 20,
          color: AppColors.buttonIconGray,
        ),
      ),
    );
  }
}

class _PageDotIndicator extends StatelessWidget {
  final int totalDots;
  final int activeIndex;

  const _PageDotIndicator({
    required this.totalDots,
    required this.activeIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.dotIndicatorGray,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.dotBorderGray, width: 1.5),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(totalDots, (index) {
          final isActive = index == activeIndex;
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 3.5),
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? AppColors.teal : AppColors.white,
            ),
          );
        }),
      ),
    );
  }
}
