import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class GameWheelScreen extends StatefulWidget {
  const GameWheelScreen({super.key});

  @override
  _GameWheelScreenState createState() => _GameWheelScreenState();
}

class _GameWheelScreenState extends State<GameWheelScreen> {
  final String apiBaseUrl = "https://preprod-orange.ernst.tn";
  bool isSpinning = false;
  String rewardMessage = "Spin to win!";
  String? giftImageUrl;

  // Function to play the game (API call)
  Future<void> playGame(String playerId) async {
    setState(() => isSpinning = true);
    
    final response = await http.post(
      Uri.parse("$apiBaseUrl/Main/Api/Game/Play"),
      headers: {
        "Authorization": "Bearer YOUR_TOKEN",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "PlayerIdentificationNumber": playerId,
        "InstanceId": 1,
        "IsNewMethod": true
      }),
    );

    setState(() => isSpinning = false);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final giftId = data["GiftId"];
      rewardMessage = "🎁 You won a prize!";
      fetchGiftImage(giftId);
    } else {
      rewardMessage = "❌ Error spinning the wheel!";
    }

    setState(() {});
  }

  // Function to fetch gift details
  Future<void> fetchGiftImage(int giftId) async {
    final response = await http.get(
      Uri.parse("$apiBaseUrl/Main/api/game/GetGiftImage?giftId=$giftId"),
      headers: {
        "Authorization": "Bearer YOUR_TOKEN",
      },
    );

    if (response.statusCode == 200) {
      setState(() => giftImageUrl = jsonDecode(response.body)["imageUrl"]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Spin the Wheel")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isSpinning 
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: () => playGame("123456789"), // Replace with real player ID
                  child: const Text("🎮 Spin the Wheel"),
                ),

            const SizedBox(height: 20),
            Text(rewardMessage, style: const TextStyle(fontSize: 18)),

            if (giftImageUrl != null)
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Image.network(giftImageUrl!),
              ),
          ],
        ),
      ),
    );
  }
}
