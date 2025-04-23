class Report {
  final String agentName;
  final int totalSales;
  final String date;

  Report({
    required this.agentName,
    required this.totalSales,
    required this.date,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      agentName: json['agentName'],
      totalSales: json['totalSales'],
      date: json['date'],
    );
  }
}
