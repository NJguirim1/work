import 'package:flutter/material.dart';
import '../controllers/game_controller.dart';
import '../models/game_model.dart';

class GameView extends StatefulWidget {
  final String playerIdentificationNumber;
  final int instanceId;
  final String token;

  const GameView({
    required this.playerIdentificationNumber,
    required this.instanceId,
    required this.token,
    Key? key,
  }) : super(key: key);

  @override
  State<GameView> createState() => _GameViewState();
}

class _GameViewState extends State<GameView> {
  final GameController _controller = GameController();
  bool _isLoading = false;
  String? _message;

  void _playGame() async {
    setState(() {
      _isLoading = true;
      _message = null;
    });

    final response = await _controller.playGame(
      GamePlayRequest(
        playerIdentificationNumber: widget.playerIdentificationNumber,
        instanceId: widget.instanceId,
        isNewMethod: true,  // Make sure your model has this field!
      ),
      widget.token,
    );

    setState(() {
      _isLoading = false;
      _message = response.message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Roue de la chance'),
        backgroundColor: const Color.fromARGB(255, 206, 76, 20),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/spin_wheel.png',
                height: 250,
              ),
              const SizedBox(height: 30),
              ElevatedButton.icon(
                onPressed: _isLoading ? null : _playGame,
                icon: const Icon(Icons.play_arrow),
                label: const Text('JOUER'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 195, 90, 10),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(160, 50),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator()
              else if (_message != null)
                Text(
                  _message!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
