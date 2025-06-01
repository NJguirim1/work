import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class PortabiliteSimController {
  final String baseUrl = 'http://preprod-orange.ernst.tn/';

  Future<http.Response> submitPortabiliteSim({
    required String token,
    required String iccid,
    required String cin,
    required String portabilityNumber,
    required File frontCinImage,
    required File backCinImage,
    required File rioSignatureImage,
    required File contractImage, required File portabilityNumberImage,
  }) async {
    final url = Uri.parse(baseUrl + 'Main/Api/Sims/CreateSell');

    // Convertir les images en base64
    String frontCinBase64 = base64Encode(await frontCinImage.readAsBytes());
    String backCinBase64 = base64Encode(await backCinImage.readAsBytes());
    String rioSignatureBase64 = base64Encode(await rioSignatureImage.readAsBytes());
    String contractBase64 = base64Encode(await contractImage.readAsBytes());

    final body = {
      'Type': 1, // 1 = Portabilité
      'IccId': iccid,
      'NationalIdentificationNumber': cin,
      'PassportNumber': '', // inutilisé pour la portabilité
      'SellPointId': '2040', // à adapter dynamiquement si besoin
      'Latitude': '35.667336',
      'Longitude': '10.9001284',
      'City': 'SAYADA',
      'Country': 'TN',
      'InChargeSupervisorId': '1507', // à adapter si besoin
      'DateEnvoi': DateTime.now().toIso8601String().split('.').first,
      'Portability_NationalIdentificationNumberFrontImage': frontCinBase64,
      'Portability_NationalIdentificationNumberBackImage': backCinBase64,
      'Portability_RioClientSignatureImage': rioSignatureBase64,
      'Portability_ContractImage': contractBase64,
      'PortabilityNumber': portabilityNumber,
    };

    print('📝 Champs envoyés : $body');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    print('📨 Status Code: ${response.statusCode}');
    print('📨 API Response: ${response.body}');

    return response;
  }
}
