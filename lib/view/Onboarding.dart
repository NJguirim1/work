import 'package:flutter/material.dart';
import 'package:flutter_application_1/view/Login_screen.dart';
import 'package:get/get.dart';


class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "image": "assets/images/stock.jpg",
      "title": "Gérez votre stock facilement",
      "description": "Suivez et gérez l'inventaire des cartes SIM en toute simplicité."
    },
    {
      "image": "assets/images/sales.jpg",
      "title": "Enregistrez vos ventes",
      "description": "Ajoutez et suivez vos ventes de cartes SIM en quelques clics."
    },
    {
      "image": "assets/images/tool.jpg",
      "title": "Outils et support pour les agents",
      "description": "Accédez aux outils essentiels pour simplifier votre quotidien."
    }
  ];

  void _nextPage() {
    if (_currentIndex < onboardingData.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      Get.off(() => const LoginScreen()); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemCount: onboardingData.length,
              itemBuilder: (context, index) {
                return _buildOnboardingPage(
                  onboardingData[index]["image"]!,
                  onboardingData[index]["title"]!,
                  onboardingData[index]["description"]!,
                );
              },
            ),
          ),
          _buildBottomNavigation(),
        ],
      ),
    );
  }

  Widget _buildOnboardingPage(String imagePath, String title, String description) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(imagePath, height: 250),
          const SizedBox(height: 30),
          Text(
            title,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.orange.shade800),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => Get.off(() => const LoginScreen()),
            child: Text("Passer", style: TextStyle(color: Colors.orange.shade800, fontSize: 16)),
          ),
          Row(
            children: List.generate(
              onboardingData.length,
              (index) => Container(
                margin: const EdgeInsets.symmetric(horizontal: 5),
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentIndex == index ? Colors.orange.shade800 : Colors.grey.shade400,
                ),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: _nextPage,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange.shade800,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: Text(_currentIndex == onboardingData.length - 1 ? "Commencer" : "Suivant"),
          ),
        ],
      ),
    );
  }
}
