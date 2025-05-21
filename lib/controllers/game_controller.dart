import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/game_model.dart';

class GameController {
  final String apiUrl = 'http://preprod-orange.ernst.tn/Main/Api/Game/Play';

  Future<GamePlayResponse> playGame(GamePlayRequest request, String token) async {
    try {
      final requestBody = request.toJson();

      print('Token used: $token');  // Debug token here
      print('📤 Sending request to $apiUrl');
      print('📦 Request body: ${jsonEncode(requestBody)}');

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(requestBody),
      );

      print('📥 Response status: ${response.statusCode}');
      print('📥 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return GamePlayResponse.fromJson(json);
      } else if (response.statusCode == 401) {
        return GamePlayResponse(success: false, message: 'Erreur: non autorisé (401)');
      } else {
        return GamePlayResponse(success: false, message: 'Erreur serveur (${response.statusCode})');
      }
    } catch (e) {
      return GamePlayResponse(success: false, message: 'Erreur: $e');
    }
  }
}
