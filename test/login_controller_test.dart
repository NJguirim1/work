import 'package:flutter_application_1/controllers/Login_controller.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_application_1/models/login_model.dart';
import 'package:mockito/mockito.dart';

import 'mocks/mocks.mocks.dart';

void main() {
  group('LoginController.authenticateUser', () {
    late MockClient mockClient;
    late LoginController controller;

    setUp(() {
      mockClient = MockClient();
      controller = LoginController(client: mockClient, deviceIdOverride: 'test-device-id');
    });

    test('returns LoginModel on successful authentication', () async {
      final fakeResponse = {
        'Success': true,
        'Data': null,
        'Error': '',
        'Body': {
          'Id': 1444,
          'Reference': '310',
          'Name': 'ABDOULI NOOMAN',
          'Username': 'noomana',
          'Type': 3,
          'TypeText': 'Superviseur terrain',
          'Token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjE0NDQiLCJOYW1lIjoiQUJET1VMSSBOT09NQU4iLCJVc2VybmFtZSI6Im5vb21hbmEiLCJUeXBlIjoiRmllbGRTdXBlcnZpc29yIiwibmJmIjoxNzQ5NzM5MzM0LCJleHAiOjE3NDk3NDI5MzQsImlhdCI6MTc0OTczOTMzNCwiaXNzIjoiSXNzdWVyIiwiYXVkIjoiQXVkaWVuY2UifQ.1RgRG6_IKuJnwqnd9L-eqNVRWHotLR6dchjHciJ2818',
          'CanStartGame': true,
          'SupervisorId': -1
        }
      };

      when(mockClient.post(
        Uri.parse(controller.apiUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(jsonEncode(fakeResponse), 200));

      final result = await controller.authenticateUser('noomana', 'ABDOULI555');

      expect(result, isNotNull);
      expect(result!.token, contains('eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjE0NDQiLCJOYW1lIjoiQUJET1VMSSBOT09NQU4iLCJVc2VybmFtZSI6Im5vb21hbmEiLCJUeXBlIjoiRmllbGRTdXBlcnZpc29yIiwibmJmIjoxNzQ5NzM5MzM0LCJleHAiOjE3NDk3NDI5MzQsImlhdCI6MTc0OTczOTMzNCwiaXNzIjoiSXNzdWVyIiwiYXVkIjoiQXVkaWVuY2UifQ.1RgRG6_IKuJnwqnd9L-eqNVRWHotLR6dchjHciJ2818'));
      expect(result.userName, 'noomana');
    });

    test('returns null when Success is false', () async {
      final responseBody = {
        'Success': false,
        'Error': 'Invalid credentials',
        'Data': null,
      };

      when(mockClient.post(
        Uri.parse(controller.apiUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(jsonEncode(responseBody), 200));

      final result = await controller.authenticateUser('noomana', 'ABDOULI555');

      expect(result, isNull);
    });

    test('returns null on non-200 status code', () async {
      when(mockClient.post(
        Uri.parse(controller.apiUrl),
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response('Internal server error', 500));

      final result = await controller.authenticateUser('noomana', 'ABDOULI555');

      expect(result, isNull);
    });
  });
}
