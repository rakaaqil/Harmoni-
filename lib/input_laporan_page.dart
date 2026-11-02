import 'package:flutter/material.dart';

import 'constants/app_colors.dart';
import 'laporan_saya_page.dart';

class InputLaporanPage extends StatefulWidget {
  const InputLaporanPage({super.key});

  @override
  State<InputLaporanPage> createState() => _InputLaporanPageState();
}

class _InputLaporanPageState extends State<InputLaporanPage> {
  final TextEditingController _isiLaporanController = TextEditingController();
  String? _attachedFileName;
  bool _isSending = false;

  @override
  void dispose() {
    _isiLaporanController.dispose();
    super.dispose();
  }

  void _pickFile() {
    // Simulasi file picker - dalam implementasi nyata gunakan file_picker package
    setState(() {
      _attachedFileName = 'dokumen_laporan_oktober.docx';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('File berhasil dipilih'),
        backgroundColor: AppColors.teal,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _removeFile() {
    setState(() {
      _attachedFileName = null;
    });
  }

  Future<void> _kirimLaporan() async {
    final isi = _isiLaporanController.text.trim();
    if (isi.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Isi laporan tidak boleh kosong'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _isSending = true);

    // Simulasi pengiriman
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;
    setState(() => _isSending = false);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Laporan berhasil dikirim!'),
        backgroundColor: AppColors.teal,
        duration: Duration(seconds: 2),
      ),
    );

    // Reset form
    _isiLaporanController.clear();
    setState(() => _attachedFileName = null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgGray,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLampiranSection(),
                        const SizedBox(height: 20),
                        _buildIsiLaporanSection(),
                        const SizedBox(height: 28),
                        _buildKirimButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Floating "Laporan Saya" button (kanan bawah)
            Positioned(
              right: 12,
              bottom: 24,
              child: _buildLaporanSayaButton(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: AppColors.bgGray,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: AppColors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.chevron_left,
                color: AppColors.black,
                size: 24,
              ),
            ),
          ),
          const Expanded(
            child: Center(
              child: Text(
                'Input Laporan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.black,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ),
          // Placeholder agar title tetap center
          const SizedBox(width: 38),
        ],
      ),
    );
  }

  Widget _buildLampiranSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Lampiran Pendukung',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
            letterSpacing: -0.1,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _attachedFileName == null ? _pickFile : null,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _attachedFileName != null
                    ? AppColors.teal
                    : AppColors.borderGray,
                width: 1.5,
              ),
            ),
            child: _attachedFileName == null
                ? Row(
                    children: [
                      Icon(
                        Icons.attach_file_rounded,
                        color: AppColors.buttonIconGray.withValues(alpha: 0.5),
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Unggah Dokumen atau Foto (.docx, .xlsx)',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.buttonIconGray.withValues(alpha: 0.5),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      const Icon(
                        Icons.insert_drive_file_rounded,
                        color: AppColors.teal,
                        size: 20,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          _attachedFileName!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.black,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      GestureDetector(
                        onTap: _removeFile,
                        child: const Icon(
                          Icons.close_rounded,
                          color: AppColors.logoutRed,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
        if (_attachedFileName == null) ...[
          const SizedBox(height: 6),
          GestureDetector(
            onTap: _pickFile,
            child: const Text(
              'Ketuk untuk memilih file',
              style: TextStyle(
                fontSize: 11,
                color: AppColors.teal,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildIsiLaporanSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Isi Laporan',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.black,
            letterSpacing: -0.1,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x10000000),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: _isiLaporanController,
            maxLines: 8,
            minLines: 8,
            style: const TextStyle(
              fontSize: 13.5,
              color: AppColors.black,
              height: 1.5,
            ),
            decoration: InputDecoration(
              hintText: 'Tulis rincian laporan secara detail di sini...',
              hintStyle: TextStyle(
                fontSize: 13.5,
                color: AppColors.buttonIconGray.withValues(alpha: 0.4),
                fontWeight: FontWeight.w400,
              ),
              contentPadding: const EdgeInsets.all(16),
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(color: AppColors.teal, width: 1.5),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildKirimButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isSending ? null : _kirimLaporan,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.teal,
          foregroundColor: AppColors.white,
          disabledBackgroundColor: AppColors.teal.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 2,
        ),
        child: _isSending
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: AppColors.white,
                  strokeWidth: 2.5,
                ),
              )
            : const Text(
                'KIRIM LAPORAN',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
      ),
    );
  }

  Widget _buildLaporanSayaButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LaporanSayaPage()),
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
            Text(
              'Laporan Saya',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.black,
                letterSpacing: -0.2,
              ),
            ),
            SizedBox(width: 4),
            Icon(
              Icons.chevron_right,
              color: AppColors.black,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
