import 'package:flutter/material.dart'; 
import 'package:flutter_application_1/controllers/data_controller.dart';
import 'package:get/get.dart';

class DataScreen extends StatefulWidget {
  final String token;

  const DataScreen({super.key, required this.token});

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final DataController dataController = DataController();
  List<dynamic> pointsOfSale = [];
  List<dynamic> supervisors = [];

  Map<String, dynamic>? selectedPointDeVente;
  Map<String, dynamic>? selectedSuperviseur;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void _fetchData() async {
    final pointsOfSaleData = await dataController.fetchPointsOfSale(widget.token);
    final supervisorsData = await dataController.fetchSupervisors(widget.token);

    setState(() {
      pointsOfSale = pointsOfSaleData ?? [];
      supervisors = supervisorsData ?? [];
    });
  }

  void _continue() {
    if (selectedPointDeVente != null && selectedSuperviseur != null) {
      Get.toNamed('/SimView', arguments: {
        "pointDeVente": selectedPointDeVente,
        "superviseur": selectedSuperviseur
      });
    } else {
      Get.snackbar(
        "Erreur", 
        "Veuillez sélectionner un Point de Vente et un Superviseur",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.9),
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ADVASIM', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.orange,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDropdown(
              title: 'Points de Vente',
              hint: 'Sélectionner un Point de Vente',
              items: pointsOfSale,
              selectedItem: selectedPointDeVente,
              onChanged: (value) => setState(() => selectedPointDeVente = value),
            ),
            const SizedBox(height: 20),
            _buildDropdown(
              title: 'Superviseurs',
              hint: 'Sélectionner un Superviseur',
              items: supervisors,
              selectedItem: selectedSuperviseur,
              onChanged: (value) => setState(() => selectedSuperviseur = value),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: (selectedPointDeVente != null && selectedSuperviseur != null) ? _continue : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  "Continuer",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String title,
    required String hint,
    required List<dynamic> items,
    required Map<String, dynamic>? selectedItem,
    required Function(Map<String, dynamic>?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.orange),
        ),
        const SizedBox(height: 10),
        Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<Map<String, dynamic>>(
                value: selectedItem,
                hint: Text(hint, style: const TextStyle(fontSize: 16)),
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down, color: Colors.orange, size: 30),
                items: items.map((item) {
                  return DropdownMenuItem<Map<String, dynamic>>(
                    value: item,
                    child: Text(item['Name'] ?? 'Inconnu', style: const TextStyle(fontSize: 16)),
                  );
                }).toList(),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }
}