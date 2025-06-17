import 'dart:convert';
import 'package:flutter_application_1/models/sim_model.dart';
import 'package:http/http.dart' as http;


class SimController {
  final String apiUrl = 'http://preprod-orange.ernst.tn/old/Api/Sim/GetAll?page=0';
  final String updateUrl = 'http://preprod-orange.ernst.tn/Main/Api/Sims/UpdateSell';
  final String token =  'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjE0NDQiLCJOYW1lIjoiQUJET1VMSSBOT09NQU4iLCJVc2VybmFtZSI6Im5vb21hbmEiLCJUeXBlIjoiRmllbGRTdXBlcnZpc29yIiwibmJmIjoxNzQ5OTg3NDIzLCJleHAiOjE3NDk5OTEwMjMsImlhdCI6MTc0OTk4NzQyMywiaXNzIjoiSXNzdWVyIiwiYXVkIjoiQXVkaWVuY2UifQ.TQsop-BT57XBtbdBldyR5yd3JkBX8FKucFfsAEkMlXg';

  Future<List<SimModel>> fetchSimData() async {
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((data) => SimModel.fromJson(data)).toList();
    } else {
      throw Exception('Erreur ${response.statusCode}: ${response.body}');
    }
  }

  Future<void> updateSim(SimModel sim) async {
    final url = Uri.parse(updateUrl);

    final bodyMap = {
      "SellId": sim.sellId,
      "Type": sim.type,
      "IccId": sim.contratNumber,
      "NationalIdentificationNumber": sim.cinNumber,
      "PassportNumber": sim.passportNumber ?? "",
      "SellPointId": sim.pvId ?? "",
      "Latitude": sim.latitude ?? "",
      "Longitude": sim.longitude ?? "",
      "City": sim.city ?? "",
      "Country": sim.country ?? "",
      "Standard_NationalIdentificationNumberFrontImage": sim.frontCinImage ?? "",
      "Standard_NationalIdentificationNumberBackImage": sim.backCinImage ?? "",
      "Standard_ContratImage": sim.contractImage ?? "",
      "Portability_NationalIdentificationNumberFrontImage": sim.portFrontCinImage ?? "",
      "Portability_NationalIdentificationNumberBackImage": sim.portBackCinImage ?? "",
      "Portability_RioSignatureImage": sim.rioSignatureImage ?? "",
      "Portability_RioSignatureImage2": sim.rioSignatureImage2 ?? "",
      "Portability_NumberImage": sim.portNumberImage ?? "",
      "Portability_ContratImage": sim.portContractImage ?? "",
      "Foreign_PassportImage1": sim.foreignPassportImage1 ?? "",
      "Foreign_PassportImage2": sim.foreignPassportImage2 ?? "",
      "Foreign_ContratImage": sim.foreignContractImage ?? "",
      "Airport_NationalIdentificationNumberFrontImage": sim.airportCinFront ?? "",
      "Airport_NationalIdentificationNumberBackImage": sim.airportCinBack ?? "",
      "TelephoneNumber": sim.telephoneNumber ?? "",
      "PvName": sim.pvName ?? "",
      "NameUserCentrale": sim.nameUserCentrale ?? "",
    };

    final body = json.encode(bodyMap);

    // --- Logs before sending ---
    print('--- updateSim Request ---');
    print('URL: $url');
    print('Headers: {Authorization: Bearer $token, Content-Type: application/json}');
    print('Body: $body');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: body,
    );

    // --- Logs after response ---
    print('--- updateSim Response ---');
    print('Status code: ${response.statusCode}');
    print('Body: ${response.body}');

    if (response.statusCode != 200) {
      throw Exception('Erreur lors de la mise à jour: ${response.body}');
    }
  }
}
