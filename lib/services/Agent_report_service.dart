import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://preprod-orange.ernst.tn/';
  static String token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjE0NDQiLCJOYW1lIjoiQUJET1VMSSBOT09NQU4iLCJVc2VybmFtZSI6Im5vb21hbmEiLCJUeXBlIjoiRmllbGRTdXBlcnZpc29yIiwibmJmIjoxNzQ2NzI0MTYxLCJleHAiOjE3NDY3Mjc3NjEsImlhdCI6MTc0NjcyNDE2MSwiaXNzIjoiSXNzdW'; // À remplir depuis le login

  static Future<List<dynamic>> get(String endpoint, Map<String, String> params) async {
    final uri = Uri.parse(baseUrl + endpoint).replace(queryParameters: params);
    final response = await http.get(uri, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Erreur ${response.statusCode}: ${response.body}');
    }
  }
}
