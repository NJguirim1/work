import 'package:flutter_application_1/models/login_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';



class LoginController {
  final String apiUrl = 'http://preprod-orange.ernst.tn/Main/Api/authentication/Login';
  final http.Client client;


  final String? deviceIdOverride;

  LoginController({http.Client? client, this.deviceIdOverride,    }) : client = client ?? http.Client();

  Future<LoginModel?> authenticateUser(String username, String password) async {
    final deviceId = deviceIdOverride ?? await _getDeviceId();

    Map<String, dynamic> requestBody = {
      'Login': username,
      'Password': password,
      'RememberMe': false,
      'DeviceId': deviceId,
      'DeviceType': 'android',
    };

    print('Request payload: ${jsonEncode(requestBody)}');

    final response = await client.post(
      Uri.parse(apiUrl),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(requestBody),
    );

    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

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
    return androidInfo.id;
  }
}