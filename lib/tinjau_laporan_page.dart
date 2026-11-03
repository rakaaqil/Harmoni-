import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'constants/app_colors.dart';
import 'data/report_store.dart';
import 'laporan_detail_page.dart';

class _TinjauRow {
  final String no;
  final String title;
  final String author;
  final String date;
  final String defaultStatus;

  const _TinjauRow({
    required this.no,
    required this.title,
    required this.author,
    required this.date,
    required this.defaultStatus,
  });
}

class TinjauLaporanPage extends StatefulWidget {
  final bool isKepalaRs;

  const TinjauLaporanPage({super.key, this.isKepalaRs = false});

  @override
  State<TinjauLaporanPage> createState() => _TinjauLaporanPageState();
}

class _TinjauLaporanPageState extends State<TinjauLaporanPage> {
  static const _divisions = [
    'Divisi Apotek',
    'Divisi Kebidanan',
    'Divisi Pendaftaran',
    'Divisi Rawat Inap',
    'Divisi Rawat Jalan',
    'Divisi UGD',
  ];

  static const _initialRows = [
    _TinjauRow(
      no: '1',
      title: 'Laporan xxx.xxx',
      author: 'Andi Facha H A',
      date: '05/10/2026',
      defaultStatus: 'Belum Ditandai',
    ),
    _TinjauRow(
      no: '2',
      title: 'Laporan xxx.xxx',
      author: 'M Rakha Aqil S',
      date: '05/10/2026',
      defaultStatus: 'Belum Ditandai',
    ),
    _TinjauRow(
      no: '3',
      title: 'Laporan xxx.xxx',
      author: 'Andi Facha H A',
      date: '05/10/2026',
      defaultStatus: 'Belum Ditandai',
    ),
    _TinjauRow(
      no: '4',
      title: 'Laporan xxx.xxx',
      author: 'M Rakha Aqil S',
      date: '05/10/2026',
      defaultStatus: 'Belum Ditandai',
    ),
    _TinjauRow(
      no: '5',
      title: 'Laporan xxx.xxx',
      author: 'Andi Facha H A',
      date: '05/10/2026',
      defaultStatus: 'Belum Ditandai',
    ),
    _TinjauRow(
      no: '6',
      title: 'Laporan xxx.xxx',
      author: 'M Rakha Aqil S',
      date: '05/10/2026',
      defaultStatus: 'Belum Ditandai',
    ),
    _TinjauRow(
      no: '7',
      title: 'Laporan xxx.xxx',
      author: 'Andi Facha H A',
      date: '05/10/2026',
      defaultStatus: 'Belum Ditandai',
    ),
    _TinjauRow(
      no: '8',
      title: 'Laporan xxx.xxx',
      author: 'M Rakha Aqil S',
      date: '05/10/2026',
      defaultStatus: 'Ditandai',
    ),
    _TinjauRow(
      no: '9',
      title: 'Laporan xxx.xxx',
      author: 'Andi Facha H A',
      date: '05/10/2026',
      defaultStatus: 'Ditandai',
    ),
    _TinjauRow(
      no: '10',
      title: 'Laporan xxx.xxx',
      author: 'M Rakha Aqil S',
      date: '05/10/2026',
      defaultStatus: 'Ditandai',
    ),
    _TinjauRow(
      no: '11',
      title: 'Laporan xxx.xxx',
      author: 'Andi Facha H A',
      date: '05/10/2026',
      defaultStatus: 'Ditolak',
    ),
    _TinjauRow(
      no: '12',
      title: 'Laporan xxx.xxx',
      author: 'M Rakha Aqil S',
      date: '05/10/2026',
      defaultStatus: 'Ditandai',
    ),
    _TinjauRow(
      no: '13',
      title: 'Laporan xxx.xxx',
      author: 'Andi Facha H A',
      date: '05/10/2026',
      defaultStatus: 'Ditandai',
    ),
    _TinjauRow(
      no: '14',
      title: 'Laporan xxx.xxx',
      author: 'M Rakha Aqil S',
      date: '05/10/2026',
      defaultStatus: 'Ditolak',
    ),
    _TinjauRow(
      no: '15',
      title: 'Laporan xxx.xxx',
      author: 'Andi Facha H A',
      date: '05/10/2026',
      defaultStatus: 'Ditolak',
    ),
    _TinjauRow(
      no: '16',
      title: 'Laporan xxx.xxx',
      author: 'M Rakha Aqil S',
      date: '05/10/2026',
      defaultStatus: 'Ditandai',
    ),
    _TinjauRow(
      no: '17',
      title: 'Laporan xxx.xxx',
      author: 'Andi Facha H A',
      date: '05/10/2026',
      defaultStatus: 'Ditandai',
    ),
  ];

  static const _allStatuses = {'Ditolak', 'Belum Ditandai', 'Ditandai'};

  final List<_TinjauRow> _rows = [..._initialRows];
  final _searchController = TextEditingController();
  String _selectedDivision = 'Divisi Apotek';
  int _pageIndex = 0;
  String _query = '';
  String _selectedMonth = '2026,12';
  final Set<String> _appliedStatuses = {..._allStatuses};
  Set<String> _draftStatuses = {..._allStatuses};
  bool _showFilters = false;
  bool _showDivisionSidebar = false;
  bool _selectionMode = false;
  final Set<String> _selectedNos = {};

  @override
  void initState() {
    super.initState();
    ReportStore.instance.addListener(_onStoreChanged);
  }

  @override
  void dispose() {
    ReportStore.instance.removeListener(_onStoreChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onStoreChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  String _effectiveStatus(_TinjauRow row) {
    return ReportStore.instance.statusFor(
      row.no,
      row.defaultStatus,
      isKepalaRs: widget.isKepalaRs,
    );
  }

  List<_TinjauRow> get _visibleRows {
    final query = _query.trim().toLowerCase();
    return _rows.where((row) {
      final status = _effectiveStatus(row);
      final matchesQuery =
          query.isEmpty ||
          [
            row.no,
            row.title,
            row.author,
            row.date,
            status,
          ].any((value) => value.toLowerCase().contains(query));
      return matchesQuery && _appliedStatuses.contains(status);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGray,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.only(
                      top: 12,
                      bottom: _selectionMode ? 210 : 18,
                    ),
                    child: Column(
                      children: [
                        _buildSearchBar(),
                        const SizedBox(height: 18),
                        _buildReportCard(),
                      ],
                    ),
                  ),
                  if (_selectionMode)
                    Positioned(
                      right: 18,
                      bottom: 18,
                      child: _buildSelectionActionPill(),
                    ),
                  if (_showFilters) ...[
                    Positioned.fill(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () => setState(() => _showFilters = false),
                      ),
                    ),
                    Positioned(
                      top: 35,
                      left: 0,
                      right: 0,
                      child: Center(child: _buildFilterPopup()),
                    ),
                  ],
                  if (_showDivisionSidebar) ...[
                    Positioned.fill(
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () =>
                            setState(() => _showDivisionSidebar = false),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      bottom: 0,
                      child: _TinjauDivisionSidebar(
                        divisions: _divisions,
                        selectedDivision: _selectedDivision,
                        onSelect: (division) => setState(() {
                          _selectedDivision = division;
                          _showDivisionSidebar = false;
                        }),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectionActionPill() {
    return Container(
      width: 68,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(34),
        border: Border.all(color: AppColors.borderGray, width: 2),
        boxShadow: const [
          BoxShadow(
            color: Color(0x32000000),
            blurRadius: 9,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          InkResponse(
            key: const ValueKey('tinjau-bulk-accept'),
            onTap: _onBulkAccept,
            radius: 26,
            child: Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: Color(0xFFD9D9D9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_rounded,
                color: AppColors.teal,
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 10),
          InkResponse(
            key: const ValueKey('tinjau-bulk-reject'),
            onTap: _onBulkReject,
            radius: 26,
            child: Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: Color(0xFFD9D9D9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                color: AppColors.logoutRed,
                size: 32,
              ),
            ),
          ),
          const SizedBox(height: 10),
          InkResponse(
            key: const ValueKey('tinjau-bulk-download'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: AppColors.teal,
                  content: Text(
                    'Mengunduh ${_selectedNos.length} laporan...',
                  ),
                ),
              );
            },
            radius: 26,
            child: Container(
              width: 52,
              height: 52,
              decoration: const BoxDecoration(
                color: Color(0xFFD9D9D9),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.archive_outlined,
                color: AppColors.black,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onBulkAccept() {
    if (_selectedNos.isEmpty) return;
    ReportStore.instance.setBulkStatus(
      _selectedNos,
      'Ditandai',
      isKepalaRs: widget.isKepalaRs,
    );
    setState(() {
      _selectionMode = false;
      _selectedNos.clear();
    });
  }

  Future<void> _onBulkReject() async {
    if (_selectedNos.isEmpty) return;
    final reason = await showRejectionReasonDialog(context);
    if (reason != null && mounted) {
      ReportStore.instance.setBulkStatus(
        _selectedNos,
        'Ditolak',
        reason: reason,
        isKepalaRs: widget.isKepalaRs,
      );
      setState(() {
        _selectionMode = false;
        _selectedNos.clear();
      });
    }
  }

  Future<void> _openDetail(_TinjauRow row) async {
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(
        builder: (_) => LaporanDetailPage(
          reportNo: row.no,
          title: row.title,
          author: row.author,
          date: row.date,
          canReview: true,
          isKepalaRs: widget.isKepalaRs,
        ),
      ),
    );
    if (!mounted) return;
    if (result == 'Ditandai' || result == 'Ditolak') {
      ReportStore.instance.setStatus(
        row.no,
        result!,
        isKepalaRs: widget.isKepalaRs,
      );
    }
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
            child: Semantics(
              button: true,
              label: 'Kembali',
              child: InkResponse(
                onTap: () => Navigator.of(context).pop(),
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
          ),
          const Text(
            'Tinjau Laporan',
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
    return Container(
      height: 52,
      margin: const EdgeInsets.symmetric(horizontal: 18),
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
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 340;
          final filterWidth = isCompact ? 78.0 : 94.0;
          final spacing = isCompact ? 6.0 : 8.0;
          return Row(
            children: [
              GestureDetector(
                key: const ValueKey('tinjau-division-button'),
                onTap: () => setState(() => _showDivisionSidebar = true),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(
                      BorderSide(color: AppColors.innerBorderGray, width: 1.5),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x35000000),
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.black,
                    size: 29,
                  ),
                ),
              ),
              SizedBox(width: spacing),
              Expanded(
                child: Container(
                  height: 40,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(21),
                  ),
                  child: TextField(
                    key: const ValueKey('tinjau-search-field'),
                    controller: _searchController,
                    onChanged: (value) => setState(() => _query = value),
                    textInputAction: TextInputAction.search,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 16,
                      color: AppColors.black,
                    ),
                    decoration: const InputDecoration(
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
                  ),
                ),
              ),
              SizedBox(width: spacing),
              InkWell(
                key: const ValueKey('tinjau-filter-button'),
                borderRadius: BorderRadius.circular(21),
                onTap: _openFilters,
                child: Container(
                  height: 40,
                  width: filterWidth,
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
                        size: 20,
                      ),
                      SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          'Filter',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: spacing),
              InkWell(
                key: const ValueKey('tinjau-edit-button'),
                customBorder: const CircleBorder(),
                onTap: () => setState(() {
                  _selectionMode = !_selectionMode;
                  if (!_selectionMode) {
                    _selectedNos.clear();
                  }
                }),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _selectionMode
                        ? const Color(0xFFD9D9D9)
                        : AppColors.white,
                    shape: BoxShape.circle,
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
                  child: const Icon(
                    Icons.edit_outlined,
                    color: AppColors.black,
                    size: 20,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  void _openFilters() {
    setState(() {
      _draftStatuses = {..._appliedStatuses};
      _showFilters = true;
    });
  }

  Widget _buildFilterPopup() {
    final width = math.min(300.0, MediaQuery.sizeOf(context).width - 24);
    final isBelumDiperiksa =
        _draftStatuses.length == 1 &&
        _draftStatuses.contains('Belum Ditandai');
    final isSudahDiperiksa =
        _draftStatuses.length == 2 &&
        _draftStatuses.contains('Ditandai') &&
        _draftStatuses.contains('Ditolak');

    return Material(
      color: Colors.transparent,
      child: Container(
        key: const ValueKey('tinjau-filter-popup'),
        width: width,
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 9),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0x50000000),
              blurRadius: 9,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                _statusChip('Ditolak', AppColors.logoutRed),
                const SizedBox(width: 5),
                _statusChip('Belum Ditandai', AppColors.black),
                const SizedBox(width: 5),
                _statusChip('Ditandai', AppColors.teal),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                _inspectionChip(
                  label: 'Belum Diperiksa',
                  chipKey: const ValueKey('filter-belum-diperiksa'),
                  selected: isBelumDiperiksa,
                  onTap: () => setState(() {
                    if (isBelumDiperiksa) {
                      _draftStatuses = {..._allStatuses};
                    } else {
                      _draftStatuses = {'Belum Ditandai'};
                    }
                  }),
                ),
                const SizedBox(width: 6),
                _inspectionChip(
                  label: 'Sudah Diperiksa',
                  chipKey: const ValueKey('filter-sudah-diperiksa'),
                  selected: isSudahDiperiksa,
                  onTap: () => setState(() {
                    if (isSudahDiperiksa) {
                      _draftStatuses = {..._allStatuses};
                    } else {
                      _draftStatuses = {'Ditandai', 'Ditolak'};
                    }
                  }),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _dateChip()),
                const SizedBox(width: 8),
                _applyButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _inspectionChip({
    required String label,
    required Key chipKey,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final color = AppColors.teal;
    return Expanded(
      child: InkWell(
        key: chipKey,
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Container(
          height: 34,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? color.withValues(alpha: 0.08) : AppColors.white,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: selected ? color : AppColors.innerBorderGray,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x28000000),
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.5,
              color: selected ? color : AppColors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusChip(String status, Color color) {
    final selected = _draftStatuses.contains(status);
    return Expanded(
      child: InkWell(
        onTap: () => setState(() {
          if (selected) {
            _draftStatuses.remove(status);
          } else {
            _draftStatuses.add(status);
          }
        }),
        borderRadius: BorderRadius.circular(17),
        child: Container(
          height: 36,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? color.withValues(alpha: 0.06) : AppColors.white,
            borderRadius: BorderRadius.circular(17),
            border: Border.all(
              color: selected ? color : AppColors.innerBorderGray,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x28000000),
                blurRadius: 3,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            status,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: status == 'Belum Ditandai' ? 10.5 : 11,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _dateChip() {
    return InkWell(
      onTap: _pickDate,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.innerBorderGray),
        ),
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 9),
                child: Text(
                  _selectedMonth,
                  maxLines: 1,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.black,
                  ),
                ),
              ),
            ),
            Container(
              width: 39,
              height: 38,
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.calendar_month_outlined,
                size: 21,
                color: AppColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _applyButton() {
    return InkWell(
      key: const ValueKey('tinjau-filter-apply'),
      onTap: () => setState(() {
        _appliedStatuses
          ..clear()
          ..addAll(_draftStatuses);
        _showFilters = false;
      }),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: 82,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.innerBorderGray),
          boxShadow: const [
            BoxShadow(
              color: Color(0x28000000),
              blurRadius: 3,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: const FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Terapkan',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.teal,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 3),
              Icon(Icons.check_rounded, size: 18, color: AppColors.teal),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2026, 12),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null && mounted) {
      setState(
        () => _selectedMonth =
            '${picked.year},${picked.month.toString().padLeft(2, '0')}',
      );
    }
  }

  Widget _buildReportCard() {
    final rows = _visibleRows;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      padding: const EdgeInsets.fromLTRB(16, 17, 14, 12),
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
        children: [
          Text(
            _selectedDivision,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
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
                _buildTableRow(
                  const _TinjauRow(
                    no: 'No',
                    title: 'Nama Laporan',
                    author: 'Aurthor',
                    date: 'Tanggal',
                    defaultStatus: 'Status',
                  ),
                  header: true,
                ),
                if (rows.isEmpty)
                  _buildEmptyRow()
                else
                  ...rows.map(_buildTableRow),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildEmptyRow() {
    return Container(
      height: 42,
      alignment: Alignment.center,
      color: AppColors.white,
      child: const Text(
        'Tidak ada laporan',
        style: TextStyle(fontSize: 11, color: AppColors.black),
      ),
    );
  }

  Widget _buildTableRow(_TinjauRow row, {bool header = false}) {
    final status = header ? row.defaultStatus : _effectiveStatus(row);
    final background = header
        ? AppColors.teal
        : (_rows.indexOf(row).isOdd ? AppColors.rowGray : AppColors.white);
    final textColor = header ? AppColors.white : AppColors.black;

    Widget firstCol;
    if (_selectionMode) {
      if (header) {
        final visible = _visibleRows;
        final allSelected =
            visible.isNotEmpty &&
            visible.every((r) => _selectedNos.contains(r.no));
        firstCol = GestureDetector(
          key: const ValueKey('tinjau-select-all'),
          onTap: () => setState(() {
            if (allSelected) {
              for (final r in visible) {
                _selectedNos.remove(r.no);
              }
            } else {
              for (final r in visible) {
                _selectedNos.add(r.no);
              }
            }
          }),
          child: Center(
            child: Icon(
              allSelected
                  ? Icons.check_box_rounded
                  : Icons.check_box_outline_blank_rounded,
              size: 18,
              color: AppColors.white,
            ),
          ),
        );
      } else {
        final isSelected = _selectedNos.contains(row.no);
        firstCol = GestureDetector(
          key: ValueKey('tinjau-check-${row.no}'),
          onTap: () => _toggleRowSelection(row.no),
          child: Center(
            child: Icon(
              isSelected
                  ? Icons.check_box_rounded
                  : Icons.check_box_outline_blank_rounded,
              size: 18,
              color: isSelected ? AppColors.teal : AppColors.black,
            ),
          ),
        );
      }
    } else {
      firstCol = _tableText(
        row.no,
        header: header,
        color: textColor,
        align: TextAlign.center,
      );
    }

    final content = Container(
      height: header ? 31 : 33,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          SizedBox(width: 32, child: firstCol),
          Expanded(
            flex: 4,
            child: _tableText(row.title, header: header, color: textColor),
          ),
          Expanded(
            flex: 3,
            child: _tableText(row.author, header: header, color: textColor),
          ),
          SizedBox(
            width: 62,
            child: _tableText(row.date, header: header, color: textColor),
          ),
          SizedBox(
            width: 64,
            child: _tableText(
              status,
              header: header,
              color: header ? textColor : _statusColor(status),
              align: TextAlign.right,
              bold: !header,
            ),
          ),
        ],
      ),
    );
    if (header) {
      return Material(color: background, child: content);
    }
    return Material(
      color: background,
      child: InkWell(
        key: ValueKey('tinjau-row-${row.no}'),
        onTap: () {
          if (_selectionMode) {
            _toggleRowSelection(row.no);
          } else {
            _openDetail(row);
          }
        },
        child: content,
      ),
    );
  }

  void _toggleRowSelection(String no) {
    setState(() {
      if (_selectedNos.contains(no)) {
        _selectedNos.remove(no);
      } else {
        _selectedNos.add(no);
      }
    });
  }

  Widget _tableText(
    String value, {
    required bool header,
    required Color color,
    TextAlign align = TextAlign.left,
    bool bold = false,
  }) {
    return Text(
      value,
      maxLines: 1,
      softWrap: false,
      overflow: TextOverflow.ellipsis,
      textAlign: align,
      style: TextStyle(
        fontSize: header ? 10.5 : 10.2,
        fontWeight: bold ? FontWeight.w700 : FontWeight.w400,
        color: color,
      ),
    );
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'Ditandai':
        return AppColors.teal;
      case 'Ditolak':
        return AppColors.logoutRed;
      default:
        return AppColors.black;
    }
  }

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _CircularArrowButton(
          icon: Icons.chevron_left_rounded,
          onTap: () =>
              setState(() => _pageIndex = (_pageIndex - 1).clamp(0, 5).toInt()),
        ),
        const SizedBox(width: 10),
        Container(
          height: 20,
          padding: const EdgeInsets.symmetric(horizontal: 2),
          decoration: BoxDecoration(
            color: const Color(0xFFD9D9D9),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Color(0x30000000),
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(
              6,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: index == _pageIndex ? AppColors.teal : AppColors.white,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        _CircularArrowButton(
          icon: Icons.chevron_right_rounded,
          onTap: () =>
              setState(() => _pageIndex = (_pageIndex + 1).clamp(0, 5).toInt()),
        ),
      ],
    );
  }
}

class _CircularArrowButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircularArrowButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 27,
        height: 27,
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
        child: Icon(icon, size: 20, color: AppColors.buttonIconGray),
      ),
    );
  }
}

class _TinjauDivisionSidebar extends StatelessWidget {
  final List<String> divisions;
  final String selectedDivision;
  final ValueChanged<String> onSelect;

  const _TinjauDivisionSidebar({
    required this.divisions,
    required this.selectedDivision,
    required this.onSelect,
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
              return GestureDetector(
                key: ValueKey('tinjau-division-$division'),
                onTap: () => onSelect(division),
                child: Container(
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFF16B5AE)
                        : const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(14),
                  ),
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
              );
            },
          ),
        ),
      ),
    ),
  );
}
