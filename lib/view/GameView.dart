import 'package:flutter/material.dart';
import '../controllers/game_controller.dart';
import '../models/gift_model.dart';
import '../models/play_result_model.dart';

class GameView extends StatefulWidget {
  final String token;
  final String playerId;
  final String sellPointId;
  final int instanceId;

  const GameView({
    Key? key,
    required this.token,
    required this.playerId,
    required this.sellPointId,
    required this.instanceId,
  }) : super(key: key);

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  late GameController _controller;
  PlayResult? _playResult;
  List<Gift> _gifts = [];
  String? _giftImageUrl;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = GameController(
      token: widget.token,
      playerId: widget.playerId,
      sellPointId: widget.sellPointId,
      instanceId: widget.instanceId,
    );
    _loadAvailableGifts();
  }

  Future<void> _loadAvailableGifts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final gifts = await _controller.getAvailableGifts();
      setState(() {
        _gifts = gifts;
      });
    } catch (e) {
      setState(() {
        _error = "Failed to load gifts: $e";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _playGame() async {
    setState(() {
      _isLoading = true;
      _error = null;
      _playResult = null;
      _giftImageUrl = null;
    });
    try {
      final result = await _controller.playGame();
      String? imageUrl;
      if (result.hasWon) {
        imageUrl = await _controller.getGiftImage(result.giftId);
      }
      setState(() {
        _playResult = result;
        _giftImageUrl = imageUrl;
      });
    } catch (e) {
      setState(() {
        _error = "Error playing game: $e";
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Widget _buildGiftList() {
    if (_gifts.isEmpty) {
      return const Text("No gifts available.");
    }
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _gifts.length,
        itemBuilder: (context, index) {
          final gift = _gifts[index];
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.orange),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Text(gift.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(gift.description),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildResult() {
    if (_playResult == null) return const SizedBox.shrink();

    if (!_playResult!.hasWon) {
      return const Text("You did not win this time. Try again!");
    }

    return Column(
      children: [
        Text("Congratulations! You won a gift with ID: ${_playResult!.giftId}"),
        if (_giftImageUrl != null && _giftImageUrl!.isNotEmpty)
          Image.network(_giftImageUrl!)
        else
          const Text("Loading gift image..."),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Game - Wheel of Fortune"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    "Available Gifts",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  _buildGiftList(),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _playGame,
                    child: const Text("Play the Game"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (_error != null)
                    Text(_error!, style: const TextStyle(color: Colors.red)),
                  _buildResult(),
                ],
              ),
      ),
    );
  }
}
