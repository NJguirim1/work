import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sim_model.dart';

class SimController {
  final String apiUrl = 'http://preprod-orange.ernst.tn/old/Api/Sim/GetAll?page=0';
  final String updateUrl = 'http://preprod-orange.ernst.tn/Main/Api/Sims/UpdateSell';
  final String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjEwMDciLCJOYW1lIjoidGVycmFpbiogdGVycmFpbiIsIlVzZXJuYW1lIjoidGVycmFpbiIsIlR5cGUiOiJGaWVsZEFnZW50IiwibmJmIjoxNzM5OTAzNDgzLCJleHAiOjE3Mzk5MDcwODMsImlhdCI6MTczOTkwMzQ4MywiaXNzIjoiSXNzdWVyIiwiYXVkIjoiQXVkaWVuY2UifQ.6GwWfbQRThy0b2qMeri_3bZBj31la-Ag2mFJB-Vz6Hg';

  // 🔄 Fetch SIM Data
  Future<List<SimModel>> fetchSimData() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((data) => SimModel.fromJson(data)).toList();
      } else {
        throw Exception(
            'Erreur ${response.statusCode}: ${response.reasonPhrase}\n${response.body}');
      }
    } catch (e) {
      throw Exception('Échec de chargement des données: $e');
    }
  }

 
  Future<void> updateSim(SimModel sim) async {
    try {
      final response = await http.post(
        Uri.parse(updateUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "CinNumber": sim.cinNumber,
          "DateEmission": sim.dateEmission,
          "State": _getStateText(sim.state), 
          "ContratNumber": sim.contratNumber,
          "TelephoneNumber": sim.telephoneNumber,
          "PvName": sim.pvName,
          "NameUserCentrale": sim.nameUserCentrale,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Erreur ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur lors de la mise à jour de la SIM: $e');
    }
  }

  // Helper to convert state integer to text
  String _getStateText(int state) {
    switch (state) {
      case 1:
        return "En attente";
      case 2:
        return "Validée";
      case 3:
        return "Rejetée";
      default:
        return "Inconnu";
    }
  }
}
