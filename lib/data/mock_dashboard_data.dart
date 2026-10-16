import '../models/dashboard_data_model.dart';

class MockDashboardData {
  MockDashboardData._();

  static const medicineStocks = [
    MedicineStock(
      no: '1',
      name: 'Paracetamol',
      unit: 'Tablet',
      quantity: '320',
    ),
    MedicineStock(
      no: '2',
      name: 'Amoxicillin',
      unit: 'Kapsul',
      quantity: '185',
    ),
    MedicineStock(
      no: '3',
      name: 'Omeprazole',
      unit: 'Kapsul',
      quantity: '240',
    ),
    MedicineStock(
      no: '4',
      name: 'Cetirizine',
      unit: 'Tablet',
      quantity: '96',
    ),
    MedicineStock(
      no: '5',
      name: 'Ringer laktat',
      unit: 'Botol',
      quantity: '58',
    ),
  ];

  static const reports = [
    ReportItem(
      no: '1',
      title: 'Laporan xxx.xxx',
      author: 'Andi Facha H A',
      date: '05/10/2026',
    ),
    ReportItem(
      no: '2',
      title: 'Laporan xxx.xxx',
      author: 'M Rakha Aqil S',
      date: '05/10/2026',
    ),
    ReportItem(
      no: '3',
      title: 'Laporan xxx.xxx',
      author: 'Andi Facha H A',
      date: '05/10/2026',
    ),
    ReportItem(
      no: '4',
      title: 'Laporan xxx.xxx',
      author: 'M Rakha Aqil S',
      date: '05/10/2026',
    ),
    ReportItem(
      no: '5',
      title: 'Laporan xxx.xxx',
      author: 'Andi Facha H A',
      date: '05/10/2026',
    ),
    ReportItem(
      no: '6',
      title: 'Laporan xxx.xxx',
      author: 'M Rakha Aqil S',
      date: '05/10/2026',
    ),
  ];
}
