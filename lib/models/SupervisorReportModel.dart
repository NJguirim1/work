class SupervisorReport {
  final String agentName;
  final int normales;
  final int portabilites;
  final int total;

  SupervisorReport({
    required this.agentName,
    required this.normales,
    required this.portabilites,
    required this.total,
  });

  factory SupervisorReport.fromJson(Map<String, dynamic> json) {
    return SupervisorReport(
      agentName: json['FieldUserName'] ?? 'Inconnu',
      normales: json['FieldUserNormalSales'] ?? 0,
      portabilites: json['FieldUserPortabilitySales'] ?? 0,
      total: json['Total'] ?? 0,
    );
  }
}
