import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/gift_model.dart';
import '../models/play_result_model.dart';

class GameController {
  final String baseUrl = "http://preprod-orange.ernst.tn/Main/Api/Game";
  final String token;
  final String playerId;
  final String sellPointId;
  final int instanceId;

  GameController({
    required this.token,
    required this.playerId,
    required this.sellPointId,
    required this.instanceId,
  });

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

  Future<PlayResult> playGame({bool isNewMethod = true}) async {
    final url = Uri.parse("$baseUrl/Play");
    final body = json.encode({
      "InstanceId": instanceId,
      "PlayerIdentificationNumber": playerId,
      "IsNewMethod": isNewMethod,
    });

    print("▶️ POST $url");
    print("🔐 Headers: $_headers");
    print("📦 Body: $body");

    final response = await http.post(url, headers: _headers, body: body);

    print("📥 Response Status: ${response.statusCode}");
    print("📥 Response Body: ${response.body}");

    if (response.statusCode == 200) {
      return PlayResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('❌ Failed to play game: ${response.statusCode} ${response.body}');
    }
  }

  Future<List<Gift>> getAvailableGifts({bool isPortability = false}) async {
    final url = Uri.parse("$baseUrl/GetAvailableGifts");
    final body = json.encode({
      "PlayerIdentificationNumber": playerId,
      "SellPointId": sellPointId,
      "IsPortability": isPortability,
    });

    print("▶️ POST $url");
    print("🔐 Headers: $_headers");
    print("📦 Body: $body");

    final response = await http.post(url, headers: _headers, body: body);

    print("📥 Response Status: ${response.statusCode}");
    print("📥 Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((e) => Gift.fromJson(e)).toList();
    } else {
      throw Exception('❌ Failed to get available gifts: ${response.statusCode} ${response.body}');
    }
  }

  Future<String> getGiftImage(int giftId) async {
    final url = Uri.parse("$baseUrl/GetGiftImage?giftId=$giftId");

    print("▶️ GET $url");
    print("🔐 Headers: $_headers");

    final response = await http.get(url, headers: _headers);

    print("📥 Response Status: ${response.statusCode}");
    print("📥 Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['imageUrl'] ?? '';
    } else {
      throw Exception('❌ Failed to get gift image: ${response.statusCode} ${response.body}');
    }
  }
}
