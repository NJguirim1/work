import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/location_controller.dart';
import 'package:flutter_application_1/controllers/login_controller.dart';
import 'package:flutter_application_1/services/location_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoginController loginController = LoginController();
  final LocationController locationController = LocationController();

  String server = 'Serveur Orange';

  void _authenticate() async {
    final username = usernameController.text;
    final password = passwordController.text;

    if (username.isEmpty) {
      _showErrorMessage("Le nom d'utilisateur est vide. Veuillez le remplir.");
      return;
    }

    final loginModel = await loginController.authenticateUser(username, password);
    if (loginModel != null) {
      print('✅ Authentification réussie !');
      await _handleLocationAndPhoto();
    } else {
      print('❌ Échec de l’authentification');
      _showErrorMessage('Échec de l’authentification. Vérifiez vos identifiants.');
    }
  }

  Future<void> _handleLocationAndPhoto() async {
    await LocationService.instance.getUserLocation(controller: locationController);

    if (locationController.userLocation.value != null) {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        print('📸 Photo prise: ${pickedFile.path}');
      }
      Get.toNamed('/dataScreen');
    } else {
      _showErrorMessage(locationController.errorDescription.value);
    }
  }

  void _showErrorMessage(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Erreur', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Réessayer', style: TextStyle(color: Colors.orange)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFA726), Color(0xFFFF7043)], // Dégradé orange
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 60),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Image.asset(
                'assets/images/hash.jpg', 
                width: 150,
                height: 150,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 20),
              _buildFancyText("ADVASIM"),
              const SizedBox(height: 30),

              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildTextField(usernameController, "Nom d'utilisateur", FontAwesomeIcons.userAlt),
                      const SizedBox(height: 20),
                      _buildTextField(passwordController, "Mot de passe", FontAwesomeIcons.lock, isPassword: true),
                      const SizedBox(height: 30),
                      const Text(
                        'Sélectionnez le serveur :',
                        style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      _buildServerSelection(),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

             
              ElevatedButton.icon(
                onPressed: _authenticate,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                  textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  elevation: 12,
                ),
                icon: const FaIcon(FontAwesomeIcons.unlockAlt),
                label: const Text("S'AUTHENTIFIER"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPassword = false}) {
    return TextField(
      controller: controller,
      obscureText: isPassword,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: Colors.orange),
        ),
        prefixIcon: FaIcon(icon, color: Colors.orange),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }

  Widget _buildServerSelection() {
    List<String> servers = ['Serveur Advasim 1', 'Serveur Advasim 2', 'Serveur Preprod', 'Serveur Orange'];
    return Column(
      children: servers.map((srv) {
        return RadioListTile<String>(
          title: Text(srv, style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
          value: srv,
          activeColor: Colors.orange,
          groupValue: server,
          onChanged: (String? value) {
            setState(() {
              server = value!;
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildFancyText(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.bold,
        fontFamily: 'Pacifico',
        color: Colors.white, 
      ),
    );
  }
}
