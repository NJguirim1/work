import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/sim_model.dart';

class SimController {
  final String apiUrl = 'http://preprod-orange.ernst.tn/old/Api/Sim/GetAll?page=0';
  final String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjEwMDciLCJOYW1lIjoidGVycmFpbiogdGVycmFpbiIsIlVzZXJuYW1lIjoidGVycmFpbiIsIlR5cGUiOiJGaWVsZEFnZW50IiwibmJmIjoxNzM5OTAzNDgzLCJleHAiOjE3Mzk5MDcwODMsImlhdCI6MTczOTkwMzQ4MywiaXNzIjoiSXNzdWVyIiwiYXVkIjoiQXVkaWVuY2UifQ.6GwWfbQRThy0b2qMeri_3bZBj31la-Ag2mFJB-Vz6Hg'; // Remplace par ton token

  Future<List<SimModel>> fetchSimData() async {
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {'Authorization': 'Bearer $token'},
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
}
