import 'package:flutter/foundation.dart';

class ReportRowData {
  final String no;
  final String title;
  final String author;
  final String date;
  final String status;
  final String? rejectionReason;

  const ReportRowData({
    required this.no,
    required this.title,
    required this.author,
    required this.date,
    required this.status,
    this.rejectionReason,
  });

  ReportRowData copyWith({
    String? no,
    String? title,
    String? author,
    String? date,
    String? status,
    String? rejectionReason,
  }) {
    return ReportRowData(
      no: no ?? this.no,
      title: title ?? this.title,
      author: author ?? this.author,
      date: date ?? this.date,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }
}

/// Store terpusat untuk status verifikasi laporan Kepala Divisi dan Kepala RS.
class ReportStore extends ChangeNotifier {
  ReportStore._();

  static final ReportStore instance = ReportStore._();

  final Map<String, String> _statusOverrides = {};
  final Map<String, String> _rsStatusOverrides = {};
  final Map<String, String> _rejectionReasons = {};

  Map<String, String> get statusOverrides =>
      Map.unmodifiable(_statusOverrides);

  Map<String, String> get rsStatusOverrides =>
      Map.unmodifiable(_rsStatusOverrides);

  Map<String, String> get rejectionReasons =>
      Map.unmodifiable(_rejectionReasons);

  String statusFor(String no, String defaultStatus, {bool isKepalaRs = false}) {
    if (isKepalaRs) {
      if (_rsStatusOverrides.containsKey(no)) {
        return _rsStatusOverrides[no]!;
      }
      if (_statusOverrides[no] == 'Ditandai') {
        return 'Belum Ditandai';
      }
      if (_statusOverrides[no] == 'Ditolak') {
        return 'Ditolak';
      }
      return defaultStatus;
    }
    return _statusOverrides[no] ?? defaultStatus;
  }

  String? reasonFor(String no) {
    return _rejectionReasons[no];
  }

  void setStatus(
    String no,
    String newStatus, {
    String? reason,
    bool isKepalaRs = false,
  }) {
    _applyStatus(no, newStatus, reason: reason, isKepalaRs: isKepalaRs);
    notifyListeners();
  }

  void setBulkStatus(
    Iterable<String> nos,
    String newStatus, {
    String? reason,
    bool isKepalaRs = false,
  }) {
    for (final no in nos) {
      _applyStatus(no, newStatus, reason: reason, isKepalaRs: isKepalaRs);
    }
    notifyListeners();
  }

  void _applyStatus(
    String no,
    String newStatus, {
    String? reason,
    bool isKepalaRs = false,
  }) {
    if (isKepalaRs) {
      _rsStatusOverrides[no] = newStatus;
      if (newStatus == 'Ditolak') {
        _statusOverrides[no] = 'Ditolak';
      }
    } else {
      _statusOverrides[no] = newStatus;
      if (newStatus == 'Ditandai') {
        _rsStatusOverrides.remove(no);
      }
    }
    if (reason != null && reason.isNotEmpty) {
      _rejectionReasons[no] = reason;
    } else if (newStatus != 'Ditolak') {
      _rejectionReasons.remove(no);
    }
  }

  void reset() {
    _statusOverrides.clear();
    _rsStatusOverrides.clear();
    _rejectionReasons.clear();
    notifyListeners();
  }
}
