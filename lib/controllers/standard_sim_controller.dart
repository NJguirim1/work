import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class StandardSimController {
  final String baseUrl = 'http://preprod-orange.ernst.tn/';

  Future<http.Response> submitStandardSim({
    required String token,
    required String iccid,
    required String cin,
    required File frontCinImage,
    required File backCinImage,
    required File contractImage,
  }) async {
    final url = Uri.parse(baseUrl + 'Main/Api/Sims/CreateSell');

    String frontCinBase64 = base64Encode(await frontCinImage.readAsBytes());
    String backCinBase64 = base64Encode(await backCinImage.readAsBytes());
    String contractBase64 = base64Encode(await contractImage.readAsBytes());

    final body = {
      'Type': 0,
      'IccId': iccid,
      'NationalIdentificationNumber': cin,
      'PassportNumber': '',
      'SellPointId': '2040',
      'Latitude': '35.667336',
      'Longitude': '10.9001284',
      'City': 'SAYADA',
      'Country': 'TN',
      'InChargeSupervisorId': '1507',
      'DateEnvoi': DateTime.now().toIso8601String().split('.').first,
      'Standard_NationalIdentificationNumberFrontImage': frontCinBase64,
      'Standard_NationalIdentificationNumberBackImage': backCinBase64,
      'Standard_ContratImage': contractBase64,
    };

    print('📝 Fields sent: $body');

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
