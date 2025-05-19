class AgentReport {
  final String agentName;
  final int normalSales;
  final int portabilitySales;
  final int totalSales;
  final double rate;

  AgentReport({
    required this.agentName,
    required this.normalSales,
    required this.portabilitySales,
    required this.totalSales,
    required this.rate,
  });

  factory AgentReport.fromJson(Map<String, dynamic> json) {
    return AgentReport(
      agentName: json['name'],
      normalSales: json['normalSales'],
      portabilitySales: json['portabilitySales'],
      totalSales: json['totalSales'],
      rate: json['rate'].toDouble(),
    );
  }
}
