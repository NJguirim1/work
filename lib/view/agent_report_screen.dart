import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/AgentReportController.dart';

import 'package:flutter_application_1/models/SupervisorReportModel.dart';

class SupervisorReportPage extends StatefulWidget {
  final String token;

  const SupervisorReportPage({super.key, required this.token, required String from, required String to});

  @override
  State<SupervisorReportPage> createState() => _SupervisorReportPageState();
}

class _SupervisorReportPageState extends State<SupervisorReportPage> {
  DateTime? _fromDate;
  DateTime? _toDate;
  late Future<List<SupervisorReport>>? _futureReports;
  final SupervisorReportController _controller = SupervisorReportController();

  @override
  void initState() {
    super.initState();
    _futureReports = null;
  }

  Future<void> _pickFromDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _fromDate = picked;
        if (_toDate != null && _toDate!.isBefore(_fromDate!)) {
          _toDate = _fromDate;
        }
      });
    }
  }

  Future<void> _pickToDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _toDate ?? DateTime.now(),
      firstDate: _fromDate ?? DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _toDate = picked;
      });
    }
  }

  void _loadReport() {
    if (_fromDate == null || _toDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Veuillez sélectionner les deux dates')),
      );
      return;
    }

    setState(() {
      _futureReports = _controller.fetchReport(
        token: widget.token,
        from: _formatDate(_fromDate!),
        to: _formatDate(_toDate!),
      );
    });
  }

  String _formatDate(DateTime date) {
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rapport Agents')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _pickFromDate,
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Date début',
                          hintText: 'Sélectionnez la date',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        controller: TextEditingController(
                          text: _fromDate != null ? _formatDate(_fromDate!) : '',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: _pickToDate,
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Date fin',
                          hintText: 'Sélectionnez la date',
                          suffixIcon: Icon(Icons.calendar_today),
                        ),
                        controller: TextEditingController(
                          text: _toDate != null ? _formatDate(_toDate!) : '',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _loadReport,
              child: const Text('Charger le rapport'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _futureReports == null
                  ? const Center(child: Text('Sélectionnez une plage de dates et appuyez sur Charger'))
                  : FutureBuilder<List<SupervisorReport>>(
                      future: _futureReports,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return const Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text('Erreur : ${snapshot.error}'));
                        }

                        final reports = snapshot.data ?? [];

                        if (reports.isEmpty) {
                          return const Center(child: Text('Aucun rapport trouvé.'));
                        }

                        return ListView.builder(
                          itemCount: reports.length,
                          itemBuilder: (context, index) {
                            final report = reports[index];
                            final taux = report.total > 0
                                ? ((report.normales / report.total) * 100).toStringAsFixed(2)
                                : '0.00';
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              child: ListTile(
                                title: Text(report.agentName),
                                subtitle: Text(
                                    'Normales: ${report.normales} | Portab.: ${report.portabilites} | Total: ${report.total} (Taux: $taux%)'),
                              ),
                            );
                          },
                        );
                      },
                    ),
            )
          ],
        ),
      ),
    );
  }
}
