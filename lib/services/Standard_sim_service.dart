import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/standard_sim_model.dart';

class StandardSimService {
  static Future<bool> submitStandardSim(StandardSimModel model, String token) async {
    final response = await http.post(
      Uri.parse('preprod-orange.ernst.tn/Main/Api/Sims/CreateSell'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(model.toJson()),
    );
    return response.statusCode == 200;
  }
}
