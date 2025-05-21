import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/AgentReportController.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AgentReportScreen extends StatelessWidget {
  final String token;
  final String from;
  final String to;

  late final ReportController controller;

  final TextEditingController fromController = TextEditingController();
  final TextEditingController toController = TextEditingController();

  AgentReportScreen({
    super.key,
    required this.token,
    required this.from,
    required this.to,
  }) {
    controller = Get.put(ReportController(token: token));

    // Initialiser les champs de date avec les valeurs passées
    fromController.text = from;
    toController.text = to;

    // Si les dates ne sont pas vides, on les formate et on lance la requête
    if (from.isNotEmpty && to.isNotEmpty) {
      controller.fetchReport(
        _formatDateForApi(from),
        _formatDateForApi(to),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rapport agents"),
        leading: const BackButton(),
        backgroundColor: const Color(0xFF6CA8DA),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _buildDateField(fromController, 'de')),
                const SizedBox(width: 8),
                Expanded(child: _buildDateField(toController, 'à')),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Vérifier si les dates sont valides
                  if (fromController.text.isEmpty || toController.text.isEmpty) {
                    Get.snackbar("Erreur", "Veuillez sélectionner les deux dates.",
                        backgroundColor: Colors.redAccent, colorText: Colors.white);
                    return;
                  }

                  final fromDate = _formatDateForApi(fromController.text);
                  final toDate = _formatDateForApi(toController.text);
                  controller.fetchReport(fromDate, toDate);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue,
                  side: const BorderSide(color: Colors.blue),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('RECHERCHER'),
              ),
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.reportList.isEmpty) {
                return const Text("Aucun rapport disponible");
              }

              final total = controller.reportList.fold<int>(0, (sum, item) => sum + item.totalSales);
              final normal = controller.reportList.fold<int>(0, (sum, item) => sum + item.normalSales);
              final portab = controller.reportList.fold<int>(0, (sum, item) => sum + item.portabilitySales);
              final taux = total > 0 ? (normal / total).toStringAsFixed(2) : '0.00';

              return Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Total: $total", style: _boldStyle()),
                    Text("Taux: $taux", style: _boldStyle()),
                    Text("Normales: $normal", style: _boldStyle()),
                    Text("Portabilités: $portab", style: _boldStyle()),
                    const Divider(thickness: 2),
                    const Row(
                      children: [
                        Expanded(child: Text("Agent terrain", style: TextStyle(fontWeight: FontWeight.bold))),
                        SizedBox(width: 8),
                        Text("Norml.", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        Text("Portab.", style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(width: 8),
                        Text("Total", style: TextStyle(fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView.builder(
                        itemCount: controller.reportList.length,
                        itemBuilder: (_, index) {
                          final agent = controller.reportList[index];
                          return Row(
                            children: [
                              Expanded(child: Text(agent.agentName)),
                              const SizedBox(width: 8),
                              Text("${agent.normalSales}"),
                              const SizedBox(width: 16),
                              Text("${agent.portabilitySales}"),
                              const SizedBox(width: 16),
                              Text("${agent.totalSales}"),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDateField(TextEditingController controller, String label) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: const UnderlineInputBorder(),
      ),
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: Get.context!,
          initialDate: DateTime.now(),
          firstDate: DateTime(2022),
          lastDate: DateTime(2030),
        );
        controller.text = DateFormat('dd/MM/yyyy').format(picked!);
            },
    );
  }

  String _formatDateForApi(String input) {
    try {
      if (input.isEmpty) {
        debugPrint("Error: Date input is empty.");
        return ""; // Return empty string if the input is empty
      }
      final parsed = DateFormat('dd/MM/yyyy').parse(input);
      debugPrint("Formatted date for API: ${DateFormat('yyyy-MM-dd').format(parsed)}");
      return DateFormat('yyyy-MM-dd').format(parsed);
    } catch (e) {
      debugPrint("Error parsing date: $e");
      return ""; // Return empty string if parsing fails
    }
  }

  TextStyle _boldStyle() => const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      );
}
