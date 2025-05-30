import 'dart:convert';
import 'package:flutter_application_1/models/stat_model.dart';
import 'package:http/http.dart' as http;

Future<List<StatModel>> fetchStats({
  required String token,
  required String username,
  required String from,
  required String to,
  required String saleType,
}) async {
  final url = Uri.parse('http://preprod-orange.ernst.tn/Main/Api/Sales/Check?username=$username');

  final body = {
    'From': from,
    'To': to,
    'SaleType': saleType,
  };

  print("=== [API CALL] ===");
  print("URL: $url");
  print("Body: $body");
  print("Token: $token");
  print("==================");

  final response = await http.post(
    url,
    headers: {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    },
    body: jsonEncode(body),
  );

  print("Status Code: ${response.statusCode}");
  print("Response Body: ${response.body}");

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as List;
    return data.map((e) => StatModel.fromJson(e)).toList();
  } else {
    throw Exception('Erreur API: ${response.statusCode}');
  }
}
