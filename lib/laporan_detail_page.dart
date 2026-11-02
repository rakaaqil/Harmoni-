import 'package:flutter/material.dart';

import 'constants/app_colors.dart';
import 'data/report_store.dart';

Future<String?> showRejectionReasonDialog(BuildContext context) {
  return showDialog<String>(
    context: context,
    builder: (dialogContext) => const _RejectionReasonDialog(),
  );
}

/// Report detail with RPP Polibatam document preview.
class LaporanDetailPage extends StatelessWidget {
  final String? reportNo;
  final String title;
  final String author;
  final String date;
  final bool canReview;
  final bool isKepalaRs;

  const LaporanDetailPage({
    super.key,
    this.reportNo,
    required this.title,
    required this.author,
    required this.date,
    this.canReview = false,
    this.isKepalaRs = false,
  });

  static const TextStyle _docText = TextStyle(
    fontFamily: 'serif',
    fontSize: 7.4,
    height: 1.25,
    color: AppColors.black,
  );

  static const TextStyle _docBold = TextStyle(
    fontFamily: 'serif',
    fontSize: 7.4,
    height: 1.25,
    fontWeight: FontWeight.w700,
    color: AppColors.black,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGray,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _header(),
            Expanded(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      0,
                      12,
                      0,
                      canReview ? 110 : 24,
                    ),
                    child: Column(
                      children: [
                        _paper(_pageOne()),
                        const SizedBox(height: 14),
                        _paper(_pageTwo()),
                        const SizedBox(height: 14),
                        _paper(_pageThree()),
                      ],
                    ),
                  ),
                  Positioned(left: 12, top: 40, child: _backButton(context)),
                  if (canReview)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 18,
                      child: _actionPill(context),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header() {
    return Container(
      width: double.infinity,
      height: 66,
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      alignment: Alignment.center,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: title,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              TextSpan(
                text: ' - $author',
                style: const TextStyle(fontWeight: FontWeight.w400),
              ),
            ],
          ),
          maxLines: 1,
          style: const TextStyle(fontSize: 19, color: AppColors.black),
        ),
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Kembali',
      child: InkResponse(
        key: const ValueKey('laporan-detail-back'),
        onTap: () => Navigator.of(context).pop(),
        radius: 24,
        child: Container(
          width: 41,
          height: 41,
          decoration: const BoxDecoration(
            color: AppColors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x40000000),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: const Icon(
            Icons.chevron_left_rounded,
            size: 24,
            color: AppColors.black,
          ),
        ),
      ),
    );
  }

  Widget _paper(Widget child) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0x18000000),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _rppHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/polibatam_logo.png',
              width: 54,
              height: 40,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const SizedBox(
                width: 54,
                height: 40,
              ),
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'No.FO.8.6.1-V1 Format Rencana Pelaksanaan Proyek (RPP)',
                    style: TextStyle(
                      fontSize: 8.2,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                  SizedBox(height: 3),
                  Text(
                    '3 November 2023',
                    style: TextStyle(
                      fontSize: 8.0,
                      fontWeight: FontWeight.w700,
                      color: AppColors.black,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Container(height: 1.0, color: AppColors.black),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _pageOne() {
    const metadataRows = <(String, String)>[
      ('Nomor ID', 'PBL-IF001'),
      ('Pengusul Proyek', 'Cyntia Lasmi Andesti, S.Kom., M.Kom'),
      ('Manajer proyek', 'Cyntia Lasmi Andesti, S.Kom., M.Kom'),
      (
        'Judul Proyek',
        'HARMONI: Platform Sistem Informasi Pelaporan dan Monitoring Pelayanan\nTerintegrasi Rumah Sakit Berbasis Mobile',
      ),
      (
        'Luaran',
        'Aplikasi berbasis Mobile\nVideo Demonstrasi Aplikasi\nLaporan Teknis Proyek\nPoster Aplikasi\nManual Book\nFile Laporan Dampak SDGs\nBAST',
      ),
      ('Sponsor', '-'),
      ('Biaya', '0.00'),
      ('Klien/Pelanggan', '-'),
      ('Waktu', '1 Semester'),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _rppHeader(),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.black, width: 0.7),
          ),
          child: Column(
            children: [
              for (var i = 0; i < metadataRows.length; i++)
                Container(
                  decoration: BoxDecoration(
                    border: i < metadataRows.length - 1
                        ? const Border(
                            bottom: BorderSide(
                              color: AppColors.black,
                              width: 0.7,
                            ),
                          )
                        : null,
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          width: 78,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 1.8,
                            ),
                            child: Text(metadataRows[i].$1, style: _docBold),
                          ),
                        ),
                        Container(width: 0.7, color: AppColors.black),
                        const SizedBox(
                          width: 10,
                          child: Padding(
                            padding: EdgeInsets.symmetric(vertical: 1.8),
                            child: Text(
                              ':',
                              textAlign: TextAlign.center,
                              style: _docBold,
                            ),
                          ),
                        ),
                        Container(width: 0.7, color: AppColors.black),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 4,
                              vertical: 1.8,
                            ),
                            child: Text(metadataRows[i].$2, style: _docText),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        _numberedHeading('1.', 'Ruang lingkup'),
        const SizedBox(height: 4),
        const Padding(
          padding: EdgeInsets.only(left: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '      Ruang lingkup Sistem Laporan Rumah Sakit ini mencakup kebutuhan akan proses pelaporan kegiatan rumah sakit yang cepat, akurat dan mudah di pantau, sebagai Solusi atas permasalahan yang timbul dari proses pelaporan manual (ditulis, dicetak, direkap) yang masih digunakan oleh berbagai divisi rumah sakit seperti rawat inap, rawat jalan, UGD, apotik, kebidanan dan pendaftaran. Sistem ini melibatkan dua actor utama yaitu staf tiap divisi dan kepala rumah sakit. Pada sisi staf divisi, system menyediakan fitur input laporan sesuai jenis data pada divisi masing – masing, pengiriman laporan secara online tanpa perlu dicetak, fitur edit dan update laporan apabila terdapat kesalahan atau data tambahan, serta Riwayat laporan yang memuat jejak laporan yang pernah dikirimkan.',
                textAlign: TextAlign.justify,
                style: _docText,
              ),
              SizedBox(height: 6),
              Text(
                '      Pada sisi Kepala rumah sakit, system menyediakan fitur monitoring seluruh laporan yang masuk dari setiap divisi dalam suatu tampilan, system ini berfungsi sebagai penghubung terpusat yang mengintegrasikan data dri seluruh divisi rumah sakit secara real – time, sehingga mempercepat proses pelaporan, mengurangi kesalahan manual, dan memudahkan monitoring oleh kepala rumah sakit.',
                textAlign: TextAlign.justify,
                style: _docText,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        _numberedHeading('2.', 'Desain Umum'),
        const SizedBox(height: 2),
        const Padding(
          padding: EdgeInsets.only(left: 14),
          child: Text(
            '      Sistem pelaporan dan monitoring pelayanan rumah sakit berbasis mobile ini dirancang untuk mengintegrasikan seluruh divisi dalam proses pelaporan digital secara terpusat. Setiap pengguna seperti staff divisi, kepala divisi, rumah sakit, dan super admin login sesuai perannya masing - masing. Staf divisi bertugas membuat, mengelola, dan mengirimkan laporan pelayanan, yang kemudian divalidasi oleh system dan disimpan di database seblum di teruskan ke kepala divisi sebelum di cek dan dikonfirmasi. Setelah terverifikasi data laporan masuk ke rekapitulasi yang dapat dipantau oleh kepala rumah sakit melalui dashboard dan grafik untuk memudahkan analisis operasional tiap divisi. super admin bertanggung jawba untuk mengelola data pengguna seperti tambah, ubah, atau hapus akun. Seluruh proses terpusat di daabse yang menyimpan data pengguna, laporan, dan status verifikasi, sehingga integrasi antar divisi berjalan efisien dan real time',
            textAlign: TextAlign.justify,
            style: _docText,
          ),
        ),
        const SizedBox(height: 18),
      ],
    );
  }

  Widget _pageTwo() {
    const sprintRows = <(String, String, String, String)>[
      (
        'Sprint 1',
        'Analisis & Backlog',
        'Identifikasi kebutuhan pengguna, menentukan aktor dan fitur, menyusun Product Backlog dan prioritas fitur, menyepakati target sprint.',
        'Product Backlog dan Sprint Goal',
      ),
      (
        'Sprint 2',
        'Desain & Fondasi Sistem',
        'Membuat wireframe, menentukan alur navigasi, merancang struktur basis data dan arsitektur awal, menyiapkan lingkungan pengembangan.',
        'Prototype UI dan fondasi sistem',
      ),
      (
        'Sprint 3',
        'Implementasi Fitur Inti',
        'Mengembangkan fitur pelaporan: form pengisian/input, pencarian',
        'Increment aplikasi dengan fitur inti',
      ),
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _rppHeader(),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: SizedBox(
            width: 215,
            height: 170,
            child: CustomPaint(painter: _ArchitectureDiagramPainter()),
          ),
        ),
        const SizedBox(height: 4),
        _numberedHeading('3.', 'Konstruksi Produk'),
        const SizedBox(height: 4),
        Center(
          child: Image.asset(
            'assets/images/sprint_diagram.png',
            width: 170,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const SizedBox(height: 120),
          ),
        ),
        const SizedBox(height: 6),
        _buildSprintTable(sprintRows, includeHeader: true),
      ],
    );
  }

  Widget _pageThree() {
    const sprintRowsPage3 = <(String, String, String, String)>[
      (
        '',
        '',
        'dan melihat barang, pengelolaan/verifikasi admin, serta proses klaim/pencocokan.',
        '',
      ),
      (
        'Sprint 4',
        'Integrasi, Pengujian & Penyempurnaan',
        'Mengintegrasikan seluruh fitur, melakukan pengujian fungsional, memperbaiki bug, melakukan review hasil sprint dan menyempurnakan produk.',
        'Increment final, hasil pengujian, dan produk siap demo',
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _rppHeader(),
        _buildSprintTable(sprintRowsPage3, includeHeader: true),
        const SizedBox(height: 4),
        const Center(
          child: Text('4.     Use Case Diagram', style: _docBold),
        ),
        const SizedBox(height: 6),
        Center(
          child: Image.asset(
            'assets/images/usecase_diagram.png',
            width: 210,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) =>
                const SizedBox(height: 140),
          ),
        ),
        const SizedBox(height: 2),
        const Center(child: Text('Gambar 3', style: _docBold)),
        const SizedBox(height: 8),
        _numberedHeading(
          '5.',
          'Kebutuhan Peralatan/Perangkat dan Bahan/Komponen',
        ),
        const SizedBox(height: 2),
        _buildEquipmentTable(),
        const SizedBox(height: 28),
      ],
    );
  }

  Widget _numberedHeading(String number, String titleText) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 14, child: Text(number, style: _docBold)),
        Expanded(child: Text(titleText, style: _docBold)),
      ],
    );
  }

  Widget _buildSprintTable(
    List<(String, String, String, String)> rows, {
    required bool includeHeader,
  }) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.black, width: 0.7),
          left: BorderSide(color: AppColors.black, width: 0.7),
          right: BorderSide(color: AppColors.black, width: 0.7),
        ),
      ),
      child: Column(
        children: [
          if (includeHeader)
            _fourColRow(
              'Sprint',
              'Fokus',
              'Aktivitas Utama',
              'Output',
              header: true,
            ),
          for (final r in rows)
            _fourColRow(r.$1, r.$2, r.$3, r.$4, header: false),
        ],
      ),
    );
  }

  Widget _fourColRow(
    String c1,
    String c2,
    String c3,
    String c4, {
    required bool header,
  }) {
    final style = header ? _docBold : _docText;
    return Container(
      decoration: BoxDecoration(
        color: header ? const Color(0xFFD9D9D9) : AppColors.white,
        border: const Border(
          bottom: BorderSide(color: AppColors.black, width: 0.7),
        ),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: 20,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                child: Align(
                  alignment: header ? Alignment.center : Alignment.centerLeft,
                  child: Text(
                    c1,
                    textAlign: header ? TextAlign.center : TextAlign.left,
                    style: style,
                  ),
                ),
              ),
            ),
            Container(width: 0.7, color: AppColors.black),
            Expanded(
              flex: 26,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                child: Text(
                  c2,
                  textAlign: header ? TextAlign.center : TextAlign.left,
                  style: style,
                ),
              ),
            ),
            Container(width: 0.7, color: AppColors.black),
            Expanded(
              flex: 32,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                child: Text(
                  c3,
                  textAlign: header ? TextAlign.center : TextAlign.left,
                  style: style,
                ),
              ),
            ),
            Container(width: 0.7, color: AppColors.black),
            Expanded(
              flex: 32,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                child: Text(
                  c4,
                  textAlign: header ? TextAlign.center : TextAlign.left,
                  style: style,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEquipmentTable() {
    const rows = <(String, String, String, String, String, String, String)>[
      (
        'Inisiasi',
        'Laptop/pc',
        '1/tim',
        'Digunakan untuk membuat dan mengolah kebutuhan sistem',
        'Panduan PBL & Template RPP',
        '1',
        'Acuan dalam penyusunan format dokumen proyek',
      ),
      (
        'Design',
        'Laptop/pc /\nDraw.io',
        '1/tim\n1/tim',
        'Digunakan untuk mendesain antarmuka web',
        'Figma',
        '1',
        'Sebagai aset untuk mendesain antar muka aplikasi',
      ),
      (
        'Implement',
        'GitHub\n(Repository)\n- Visual\nStudio code',
        '1/tim\n\n1/tim',
        'Implementasi penulisan code untuk bagian front-end (mobile) dan back-end',
        'Dokumentasi\nCode\n-Dart\n-Flutter',
        '1',
        'Sebagai aset untuk menuliskan kode aplikasi mobile',
      ),
    ];

    const headerStyle = TextStyle(
      fontFamily: 'serif',
      fontSize: 6.5,
      height: 1.15,
      fontWeight: FontWeight.w700,
      color: AppColors.black,
    );
    const cellStyle = TextStyle(
      fontFamily: 'serif',
      fontSize: 6.5,
      height: 1.18,
      color: AppColors.black,
    );

    return Container(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.black, width: 0.7),
          left: BorderSide(color: AppColors.black, width: 0.7),
          right: BorderSide(color: AppColors.black, width: 0.7),
        ),
      ),
      child: Column(
        children: [
          // Merged 2-row header
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFFD9D9D9),
              border: Border(
                bottom: BorderSide(color: AppColors.black, width: 0.7),
              ),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Expanded(
                    flex: 15,
                    child: Center(
                      child: Padding(
                        padding: EdgeInsets.all(2),
                        child: Text(
                          'Fase/Proses',
                          textAlign: TextAlign.center,
                          style: headerStyle,
                        ),
                      ),
                    ),
                  ),
                  Container(width: 0.7, color: AppColors.black),
                  Expanded(
                    flex: 43,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 2,
                          ),
                          child: Text(
                            'Peralatan/Perangkat (SW/HW)',
                            textAlign: TextAlign.center,
                            style: headerStyle,
                          ),
                        ),
                        Container(height: 0.7, color: AppColors.black),
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Expanded(
                                flex: 15,
                                child: Padding(
                                  padding: EdgeInsets.all(2),
                                  child: Text(
                                    'Nama',
                                    textAlign: TextAlign.center,
                                    style: headerStyle,
                                  ),
                                ),
                              ),
                              Container(width: 0.7, color: AppColors.black),
                              const Expanded(
                                flex: 9,
                                child: Padding(
                                  padding: EdgeInsets.all(2),
                                  child: Text(
                                    'Jumlah',
                                    textAlign: TextAlign.center,
                                    style: headerStyle,
                                  ),
                                ),
                              ),
                              Container(width: 0.7, color: AppColors.black),
                              const Expanded(
                                flex: 19,
                                child: Padding(
                                  padding: EdgeInsets.all(2),
                                  child: Text(
                                    'Catatan',
                                    textAlign: TextAlign.center,
                                    style: headerStyle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(width: 0.7, color: AppColors.black),
                  Expanded(
                    flex: 42,
                    child: Column(
                      children: [
                        const Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: 2,
                            vertical: 2,
                          ),
                          child: Text(
                            'Bahan/Komponen',
                            textAlign: TextAlign.center,
                            style: headerStyle,
                          ),
                        ),
                        Container(height: 0.7, color: AppColors.black),
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              const Expanded(
                                flex: 15,
                                child: Padding(
                                  padding: EdgeInsets.all(2),
                                  child: Text(
                                    'Nama',
                                    textAlign: TextAlign.center,
                                    style: headerStyle,
                                  ),
                                ),
                              ),
                              Container(width: 0.7, color: AppColors.black),
                              const Expanded(
                                flex: 9,
                                child: Padding(
                                  padding: EdgeInsets.all(2),
                                  child: Text(
                                    'Jumlah',
                                    textAlign: TextAlign.center,
                                    style: headerStyle,
                                  ),
                                ),
                              ),
                              Container(width: 0.7, color: AppColors.black),
                              const Expanded(
                                flex: 18,
                                child: Padding(
                                  padding: EdgeInsets.all(2),
                                  child: Text(
                                    'Catatan',
                                    textAlign: TextAlign.center,
                                    style: headerStyle,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          for (final r in rows)
            Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: AppColors.black, width: 0.7),
                ),
              ),
              child: IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 15,
                      child: Padding(
                        padding: const EdgeInsets.all(2.5),
                        child: Text(r.$1, style: cellStyle),
                      ),
                    ),
                    Container(width: 0.7, color: AppColors.black),
                    Expanded(
                      flex: 15,
                      child: Padding(
                        padding: const EdgeInsets.all(2.5),
                        child: Text(r.$2, style: cellStyle),
                      ),
                    ),
                    Container(width: 0.7, color: AppColors.black),
                    Expanded(
                      flex: 9,
                      child: Padding(
                        padding: const EdgeInsets.all(2.5),
                        child: Text(r.$3, style: cellStyle),
                      ),
                    ),
                    Container(width: 0.7, color: AppColors.black),
                    Expanded(
                      flex: 19,
                      child: Padding(
                        padding: const EdgeInsets.all(2.5),
                        child: Text(r.$4, style: cellStyle),
                      ),
                    ),
                    Container(width: 0.7, color: AppColors.black),
                    Expanded(
                      flex: 15,
                      child: Padding(
                        padding: const EdgeInsets.all(2.5),
                        child: Text(r.$5, style: cellStyle),
                      ),
                    ),
                    Container(width: 0.7, color: AppColors.black),
                    Expanded(
                      flex: 9,
                      child: Padding(
                        padding: const EdgeInsets.all(2.5),
                        child: Text(r.$6, style: cellStyle),
                      ),
                    ),
                    Container(width: 0.7, color: AppColors.black),
                    Expanded(
                      flex: 18,
                      child: Padding(
                        padding: const EdgeInsets.all(2.5),
                        child: Text(r.$7, style: cellStyle),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _onTolak(BuildContext context) async {
    final reason = await showRejectionReasonDialog(context);

    if (reason != null && context.mounted) {
      if (reportNo != null) {
        ReportStore.instance.setStatus(
          reportNo!,
          'Ditolak',
          reason: reason,
          isKepalaRs: isKepalaRs,
        );
      }
      Navigator.pop(context, 'Ditolak');
    }
  }

  Widget _actionPill(BuildContext context) {
    final acceptLabel = isKepalaRs ? 'Tandai Di Terima' : 'Terima';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 44),
      child: Container(
        height: 68,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
        child: Row(
          children: [
            Expanded(
              child: Semantics(
                button: true,
                label: 'Terima laporan',
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    key: const ValueKey('laporan-terima'),
                    borderRadius: BorderRadius.circular(26),
                    onTap: () {
                      if (reportNo != null) {
                        ReportStore.instance.setStatus(
                          reportNo!,
                          'Ditandai',
                          isKepalaRs: isKepalaRs,
                        );
                      }
                      Navigator.pop(context, 'Ditandai');
                    },
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(
                          color: AppColors.innerBorderGray,
                          width: 1.2,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x30000000),
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          acceptLabel,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: AppColors.teal,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Semantics(
                button: true,
                label: 'Tolak laporan',
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    key: const ValueKey('laporan-tolak'),
                    borderRadius: BorderRadius.circular(26),
                    onTap: () => _onTolak(context),
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(
                          color: AppColors.innerBorderGray,
                          width: 1.2,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x30000000),
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Text(
                        'Tolak',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: AppColors.logoutRed,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Semantics(
              button: true,
              label: 'Unduh laporan',
              child: InkResponse(
                key: const ValueKey('laporan-download'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.teal,
                      content: Text('Mengunduh $title...'),
                    ),
                  );
                },
                radius: 26,
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppColors.innerBorderGray,
                      width: 1.2,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x30000000),
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Icon(
                    Icons.file_download_outlined,
                    color: AppColors.black,
                    size: 26,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ArchitectureDiagramPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bgPaint = Paint()..color = const Color(0xFF141414);
    canvas.drawRect(Offset.zero & size, bgPaint);

    // Subtle dark grid lines
    final gridPaint = Paint()
      ..color = const Color(0xFF262626)
      ..strokeWidth = 0.5;
    for (double x = 0; x <= size.width; x += 12) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (double y = 0; y <= size.height; y += 12) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final strokePaint = Paint()
      ..color = Colors.white70
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    const topLeft = Rect.fromLTWH(8, 12, 42, 22);
    const topRight = Rect.fromLTWH(164, 12, 42, 22);
    const bottomLeft = Rect.fromLTWH(8, 108, 42, 22);
    const bottomRight = Rect.fromLTWH(160, 108, 46, 22);
    const centerBox = Rect.fromLTWH(84, 60, 46, 22);

    // Connecting lines
    canvas.drawLine(topLeft.bottomRight, centerBox.topLeft, strokePaint);
    canvas.drawLine(topRight.bottomLeft, centerBox.topRight, strokePaint);
    canvas.drawLine(bottomLeft.topRight, centerBox.bottomLeft, strokePaint);
    canvas.drawLine(bottomRight.topLeft, centerBox.bottomRight, strokePaint);
    canvas.drawLine(
      centerBox.bottomCenter,
      Offset(size.width / 2, 136),
      strokePaint,
    );

    void drawNode(Rect rect, String label) {
      final rrect = RRect.fromRectAndRadius(rect, const Radius.circular(2));
      canvas.drawRRect(rrect, Paint()..color = const Color(0xFF1B1B1B));
      canvas.drawRRect(rrect, strokePaint);
      final tp = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 4.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      )..layout(maxWidth: rect.width - 2);
      tp.paint(
        canvas,
        Offset(
          rect.left + (rect.width - tp.width) / 2,
          rect.top + (rect.height - tp.height) / 2,
        ),
      );
    }

    drawNode(topLeft, 'Staff Divisi');
    drawNode(topRight, 'Kepala Divisi');
    drawNode(bottomLeft, 'Super Admin');
    drawNode(bottomRight, 'Kepala Rumah Sakit');
    drawNode(centerBox, 'Sistem');

    // 3D Blue Server + Database Cylinder icon at bottom center
    final sx = size.width / 2 - 12;
    const sy = 136.0;
    final serverFill = Paint()..color = const Color(0xFF3A7BD5);
    final serverLight = Paint()..color = const Color(0xFF6FB1FC);
    final serverStroke = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.7;

    final serverRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(sx, sy, 14, 26),
      const Radius.circular(1.5),
    );
    canvas.drawRRect(serverRect, serverFill);
    canvas.drawRRect(serverRect, serverStroke);
    canvas.drawLine(
      Offset(sx + 3, sy + 5),
      Offset(sx + 11, sy + 5),
      serverStroke,
    );
    canvas.drawLine(
      Offset(sx + 3, sy + 9),
      Offset(sx + 11, sy + 9),
      serverStroke,
    );

    // Database cylinder next to server
    final dbRect = Rect.fromLTWH(sx + 11, sy + 14, 12, 12);
    canvas.drawRRect(
      RRect.fromRectAndRadius(dbRect, const Radius.circular(3)),
      serverLight,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(dbRect, const Radius.circular(3)),
      serverStroke,
    );
    canvas.drawOval(Rect.fromLTWH(sx + 11, sy + 12, 12, 5), serverFill);
    canvas.drawOval(Rect.fromLTWH(sx + 11, sy + 12, 12, 5), serverStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _RejectionReasonDialog extends StatefulWidget {
  const _RejectionReasonDialog();

  @override
  State<_RejectionReasonDialog> createState() => _RejectionReasonDialogState();
}

class _RejectionReasonDialogState extends State<_RejectionReasonDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(22),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Alasan Penolakan',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.black,
              ),
            ),
            const SizedBox(height: 14),
            TextField(
              key: const ValueKey('alasan-penolakan-field'),
              controller: _controller,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Masukkan alasan penolakan...',
                hintStyle: const TextStyle(
                  fontSize: 14,
                  color: Color(0x80000000),
                ),
                filled: true,
                fillColor: const Color(0xFFF0F0F0),
                contentPadding: const EdgeInsets.all(12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    key: const ValueKey('tolak-batal'),
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.black,
                      side: const BorderSide(
                        color: AppColors.innerBorderGray,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Batal',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    key: const ValueKey('tolak-kirim'),
                    onPressed: () =>
                        Navigator.pop(context, _controller.text.trim()),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.teal,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text(
                      'Kirim',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
