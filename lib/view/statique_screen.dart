import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/stat_controller.dart';
import '../models/stat_model.dart';

class StatsScreen extends StatefulWidget {
  final String token;
  final String username;

  const StatsScreen({Key? key, required this.token, required this.username}) : super(key: key);

  @override
  State<StatsScreen> createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  final StatsController controller = Get.put(StatsController());

  DateTime _fromDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _toDate = DateTime.now();
  String _selectedType = 'Ordinaire';

  final List<String> saleTypes = ['Ordinaire', 'Portabilite', 'Autre'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Statistiques")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dates
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildDatePicker("De", _fromDate, (picked) {
                  if (picked != null) setState(() => _fromDate = picked);
                }),
                _buildDatePicker("À", _toDate, (picked) {
                  if (picked != null) setState(() => _toDate = picked);
                }),
              ],
            ),
            const SizedBox(height: 10),

            // Dropdown
            DropdownButtonFormField<String>(
              value: _selectedType,
              items: saleTypes.map((type) {
                return DropdownMenuItem(value: type, child: Text(type));
              }).toList(),
              onChanged: (value) => setState(() => _selectedType = value!),
              decoration: const InputDecoration(labelText: "Type de vente"),
            ),
            const SizedBox(height: 16),

            // Envoyer
            ElevatedButton(
              onPressed: () {
                controller.getStats(
                  widget.token,
                  widget.username,
                  DateFormat('yyyy-MM-dd').format(_fromDate),
                  DateFormat('yyyy-MM-dd').format(_toDate),
                  _selectedType,
                );
              },
              child: const Text("ENVOYER"),
            ),
            const SizedBox(height: 16),

            // Résultat
            Obx(() {
              if (controller.isLoading.value) {
                return const CircularProgressIndicator();
              }

              if (controller.statsList.isEmpty) {
                return const Text("Aucune donnée.");
              }

              return Expanded(
                child: ListView.builder(
                  itemCount: controller.statsList.length,
                  itemBuilder: (context, index) {
                    final stat = controller.statsList[index];
                    return _buildStatCard(stat);
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePicker(String label, DateTime date, Function(DateTime?) onPicked) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        TextButton(
          onPressed: () async {
            DateTime? picked = await showDatePicker(
              context: context,
              initialDate: date,
              firstDate: DateTime(2020),
              lastDate: DateTime(2030),
            );
            onPicked(picked);
          },
          child: Text(DateFormat('dd/MM/yyyy').format(date)),
        ),
      ],
    );
  }

  Widget _buildStatCard(StatModel stat) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(stat.username.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _statLine("Avec recharge", stat.avecRecharge),
            _statLine("Rech.Init.Seulement", stat.rechargeInitSeulement),
            _statLine("Fraude (0.975)", stat.fraude),
            _statLine("First Call", stat.firstCall),
            _statLine("Sans recharge", stat.sansRecharge),
            _statLine("Total", stat.total),
            _statLine("FCR", stat.fcr),
            _statLine("FCR en %", stat.fcrPercent),
          ],
        ),
      ),
    );
  }

  Widget _statLine(String label, dynamic value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(value.toString()),
      ],
    );
  }
}
