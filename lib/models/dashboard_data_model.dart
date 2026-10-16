class MedicineStock {
  final String no;
  final String name;
  final String unit;
  final String quantity;

  const MedicineStock({
    required this.no,
    required this.name,
    required this.unit,
    required this.quantity,
  });

  List<String> toRowData() => [no, name, unit, quantity];
}

class ReportItem {
  final String no;
  final String title;
  final String author;
  final String date;

  const ReportItem({
    required this.no,
    required this.title,
    required this.author,
    required this.date,
  });

  List<String> toRowData() => [no, title, author, date];
}
