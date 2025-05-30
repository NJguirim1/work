import 'dart:convert';

import 'package:flutter_application_1/models/portability_sim_model.dart';
import 'package:http/http.dart' as http;


class PortabilitySimService {
  final String baseUrl;

  PortabilitySimService(this.baseUrl);

  Future<bool> submitPortabilitySale({
    required PortabilitySimModel model,
    required String token,
    required String sellPointId,
    required String latitude,
    required String longitude,
    required String city,
    required String country,
    required String supervisorId,
  }) async {
    final url = Uri.parse('$baseUrl/Main/Api/Sims/CreateSell');
    
    final Map<String, dynamic> body = {
      "Type": 1, // Portability
      "IccId": model.iccId,
      "NationalIdentificationNumber": model.cin,
      "SellPointId": sellPointId,
      "Latitude": latitude,
      "Longitude": longitude,
      "City": city,
      "Country": country,
      "Portability_NationalIdentificationNumberFrontImage": model.frontCinImage,
      "Portability_NationalIdentificationNumberBackImage": model.backCinImage,
      "Portability_RioSignatureImage": model.rioSignatureImage,
      "Portability_RioSignatureImage2": model.rioSignatureImage,
      "Portability_NumberImage": model.portabilityNumberImage,
      "Portability_ContratImage": model.contractImage,
      "InChargeSupervisorId": supervisorId,
      "DateEnvoi": DateTime.now().toIso8601String(),
    };

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      print("Vente soumise avec succès");
      return true;
    } else {
      print("Erreur: ${response.statusCode} => ${response.body}");
      return false;
    }
  }
}
