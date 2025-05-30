import 'package:http/http.dart' as http;
import 'dart:convert';

class DataController {
  final String apiUrlPointOfSale = 'http://preprod-orange.ernst.tn/Main/Api/PointOfSale/Get';
  final String apiUrlSupervisors = 'http://preprod-orange.ernst.tn/Main/Api/Supervisors/Get';

  Future<List<dynamic>?> fetchPointsOfSale(String token) async {
    final response = await http.get(
      Uri.parse(apiUrlPointOfSale),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      print('Points of Sale Response: $responseBody'); // Print response for debugging
      if (responseBody != null) {
        return responseBody as List<dynamic>?;
      }
    } else {
      print('Failed to load points of sale: ${response.statusCode}');
    }
    return null;
  }

  Future<List<dynamic>?> fetchSupervisors(String token) async {
    final response = await http.get(
      Uri.parse(apiUrlSupervisors),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);
      print('Supervisors Response: $responseBody'); // Print response for debugging
      if (responseBody != null) {
        return responseBody as List<dynamic>?;
      }
    } else {
      print('Failed to load supervisors: ${response.statusCode}');
    }
    return null;
  }
}
