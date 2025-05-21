import 'package:flutter_application_1/models/login_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';

class LoginController {
  final String apiUrl = 'http://preprod-orange.ernst.tn/Main/Api/authentication/Login';

  Future<LoginModel?> authenticateUser(String username, String password) async {
    String deviceId = await _getDeviceId();

    Map<String, dynamic> requestBody = {
      'Login': username,  // Change 'username' to 'Login'
      'Password': password,
      'RememberMe': false,  // Add RememberMe field
      'DeviceId': deviceId,  // Add DeviceId field
      'DeviceType': 'android',  // Add DeviceType field
    };

    print('Request payload: ${jsonEncode(requestBody)}');

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );

    // Print response for debugging
    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      // Check for specific fields that indicate success
      if (responseBody['Success'] == true) {
        return LoginModel.fromJson(responseBody);
      } else {
        print('Authentication failed: ${responseBody['Error']}');
        return null;
      }
    } else {
      print('Request failed with status code: ${response.statusCode}');
      return null;
    }
  }

  Future<String> _getDeviceId() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id; // Unique device ID
  }
}
