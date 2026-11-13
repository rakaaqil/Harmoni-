import 'package:flutter/material.dart';

import '../../constants/app_colors.dart';
import '../../constants/user_options.dart';
import '../pager_dots.dart';

/// Number of user rows shown per table page.
const userTablePageSize = 15;

/// Maximum number of dots rendered under the table.
const _maxDots = 6;

/// Card containing the paginated "Daftar Data Pengguna" table.
class UserTable extends StatelessWidget {
  final List<Map<String, dynamic>> users;
  final int page;
  final String? selectedEmail;
  final ValueChanged<Map<String, dynamic>> onSelect;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const UserTable({
    super.key,
    required this.users,
    required this.page,
    required this.selectedEmail,
    required this.onSelect,
    required this.onPrev,
    required this.onNext,
  });

  static int pageCountFor(int total) =>
      total == 0 ? 1 : (total + userTablePageSize - 1) ~/ userTablePageSize;

  @override
  Widget build(BuildContext context) {
    final pageCount = pageCountFor(users.length);
    final start = page * userTablePageSize;
    final pageUsers = users
        .skip(start)
        .take(userTablePageSize)
        .toList(growable: false);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(12, 18, 12, 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
            color: Color(0x45000000),
            blurRadius: 15,
            spreadRadius: 2,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Daftar Data Pengguna',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.black,
            ),
          ),
          const SizedBox(height: 14),
          _headerRow(),
          if (pageUsers.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Text(
                'Tidak ada pengguna',
                style: TextStyle(fontSize: 12, color: Color(0xFF6B6B6B)),
              ),
            )
          else
            for (var i = 0; i < pageUsers.length; i++)
              _dataRow(pageUsers[i], start + i, i),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _pagerButton(
                const ValueKey('admin-page-prev'),
                Icons.chevron_left_rounded,
                onPrev,
              ),
              const SizedBox(width: 8),
              PagerDots(
                count: pageCount.clamp(1, _maxDots),
                active: _activeDot(page, pageCount),
              ),
              const SizedBox(width: 8),
              _pagerButton(
                const ValueKey('admin-page-next'),
                Icons.chevron_right_rounded,
                onNext,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Maps the current page onto at most [_maxDots] dots.
  static int _activeDot(int page, int pageCount) {
    if (pageCount <= _maxDots) return page;
    return (page * (_maxDots - 1) / (pageCount - 1)).round();
  }

  Widget _headerRow() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
    decoration: BoxDecoration(
      color: const Color(0xFF12B5AE),
      borderRadius: BorderRadius.circular(9),
    ),
    child: _cells(
      const ['No', 'Nama', 'Divisi', 'Role', 'Status'],
      const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        color: AppColors.white,
      ),
    ),
  );

  Widget _dataRow(Map<String, dynamic> data, int absoluteIndex, int i) {
    final email = extractUserEmail(data);
    final name = extractUserName(data);
    final division = extractUserDivision(data);
    final role = extractUserRole(data);
    final status = normalizeStatus(data['status']);
    final rowKey = email.isNotEmpty
        ? ValueKey('user-$email')
        : ValueKey('user-${data['id'] ?? absoluteIndex}');
    final selected =
        selectedEmail != null && selectedEmail!.isNotEmpty && selectedEmail == email;
    final background = selected
        ? const Color(0xFF12B5AE).withValues(alpha: 0.15)
        : (i.isEven ? AppColors.white : const Color(0xfff3f3f3));
    const style = TextStyle(fontSize: 11, color: AppColors.black);

    return Material(
      key: rowKey,
      color: background,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: () => onSelect(data),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          child: Row(
            children: [
              _cell(
                0,
                Text(
                  '${absoluteIndex + 1}',
                  textAlign: TextAlign.center,
                  style: style,
                ),
              ),
              _cell(1, _ellipsis(name, style, align: TextAlign.center)),
              _cell(
                2,
                _ellipsis(division ?? '-', style, align: TextAlign.center),
              ),
              _cell(
                3,
                _ellipsis(
                  roleShortLabel(role),
                  style,
                  align: TextAlign.center,
                ),
              ),
              _cell(
                4,
                _ellipsis(
                  statusLabel(status),
                  TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: status == 'nonaktif'
                        ? const Color(0xFFE53935)
                        : const Color(0xFF12B5AE),
                  ),
                  align: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const _flex = [2, 5, 4, 5, 4];

  Widget _cells(List<String> labels, TextStyle style) => Row(
    children: [
      for (var i = 0; i < labels.length; i++)
        _cell(i, _ellipsis(labels[i], style, align: TextAlign.center)),
    ],
  );

  Widget _cell(int column, Widget child) => Expanded(
    flex: _flex[column],
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: child,
    ),
  );

  Widget _ellipsis(
    String text,
    TextStyle style, {
    TextAlign align = TextAlign.start,
  }) => Text(
    text,
    textAlign: align,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: style,
  );

  Widget _pagerButton(Key key, IconData icon, VoidCallback onTap) =>
      InkResponse(
        key: key,
        onTap: onTap,
        radius: 18,
        child: Container(
          width: 29,
          height: 29,
          decoration: const BoxDecoration(
            color: Color(0xffd5d5d5),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x35000000),
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 22, color: const Color(0xff292929)),
        ),
      );
}
