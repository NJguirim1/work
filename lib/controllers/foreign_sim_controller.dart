import 'dart:convert';
import 'package:flutter_application_1/models/foreign_sim_model.dart';
import 'package:http/http.dart' as http;


class ForeignSimSaleController {
  final String apiUrl = "http://preprod-orange.ernst.tn/Main/Api/Sims/CreateSell";
  final String token;

  ForeignSimSaleController({required this.token});

  Future<Map<String, dynamic>> submitSale(ForeignSimSaleModel model) async {
    try {
      final headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      };

      final body = jsonEncode(model.toJson());

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        return {"success": true, "message": "Vente soumise avec succès"};
      } else {
        return {
          "success": false,
          "message": "Erreur API ${response.statusCode}: ${response.body}"
        };
      }
    } catch (e) {
      return {"success": false, "message": "Exception: $e"};
    }
  }
}
