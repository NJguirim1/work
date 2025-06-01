import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class EtrangerSimController {
  Future<http.Response> submitEtrangerSim({
    required String token,
    required String iccid,
    required String passportNumber,
    required File passportImage,
    required File contractImage,
    required String sellPointId,
    required String latitude,
    required String longitude,
    required String city,
    required String country,
    required String inChargeSupervisorId,
    required String dateEnvoi,
  }) async {
    // Read images and encode with base64 + prefix
    final passportBytes = await passportImage.readAsBytes();
    final contractBytes = await contractImage.readAsBytes();

    final passportBase64 = 'data:image/jpeg;base64,' + base64Encode(passportBytes);
    final contractBase64 = 'data:image/jpeg;base64,' + base64Encode(contractBytes);

    final Map<String, dynamic> data = {
      'Type': 2,
      'IccId': iccid,
      'PassportNumber': passportNumber.isEmpty ? '' : passportNumber,
      'SellPointId': sellPointId,
      'Latitude': latitude,
      'Longitude': longitude,
      'City': city,
      'Country': country,
      'InChargeSupervisorId': inChargeSupervisorId,
      'DateEnvoi': dateEnvoi,
      'Etranger_PassportImage': passportBase64,
      'Etranger_ContratImage': contractBase64,
    };

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final uri = Uri.parse('http://preprod-orange.ernst.tn/Main/Api/Sims/CreateSell');

    final response = await http.post(
      uri,
      headers: headers,
      body: jsonEncode(data),
    );

    return response;
  }
}
