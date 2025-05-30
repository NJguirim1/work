import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/pointage.dart';

class PointageController {
  final String baseUrl = "http://preprod-orange.ernst.tn/Main/Api/Pointage/GetPointageByIdAgent";

  Future<List<Pointage>> fetchPointages(String idAgent, String dateSelect) async {
    final uri = Uri.parse("$baseUrl?IdAgent=$idAgent&DateSelect=$dateSelect");

    print("🔄 Sending GET request to: $uri");

    try {
      final response = await http.get(uri);

      print("✅ Response status: ${response.statusCode}");
      print("📦 Response body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((e) => Pointage.fromJson(e)).toList();
      } else {
        throw Exception("❌ Failed to load pointages - status code: ${response.statusCode}");
      }
    } catch (e) {
      print("⚠️ Error during fetchPointages: $e");
      rethrow;
    }
  }
}
