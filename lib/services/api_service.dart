import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/stat_model.dart';

class ApiService {
  static Future<List<StatModel>> fetchStats({
    required String token,
    required String username,
    required String from,
    required String to,
    required String saleType,
  }) async {
    final url = Uri.parse('http://preprod-orange.ernst.tn/Main/Api/Sales/Check?username=$username');

    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'From': from,
        'To': to,
        'SaleType': saleType,
      }),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((e) => StatModel.fromJson(e)).toList();
    } else {
      throw Exception('Erreur lors du chargement des statistiques');
    }
  }

  getSupervisorReport({required String token, required String from, required String to}) {}
}
