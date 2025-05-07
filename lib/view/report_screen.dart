import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/report_controller.dart';

class ReportScreen extends StatelessWidget {
  final ReportController controller = Get.put(ReportController());
  final String token;
  final String from;
  final String to;

  ReportScreen({super.key, required this.token, required this.from, required this.to});

  @override
  Widget build(BuildContext context) {
    controller.fetchReports(token, from, to);

    return Scaffold(
      appBar: AppBar(title: const Text('Rapport des Agents')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.reports.isEmpty) {
          return const Center(child: Text('Aucun rapport trouvé.'));
        }

        return ListView.builder(
          itemCount: controller.reports.length,
          itemBuilder: (context, index) {
            final report = controller.reports[index];
            return ListTile(
              title: Text(report.agentName),
              subtitle: Text("Ventes: ${report.totalSales} | Date: ${report.date}"),
            );
          },
        );
      }),
    );
  }
}
