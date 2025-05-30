import 'package:dio/dio.dart';
import 'package:flutter_application_1/models/SupervisorReportModel.dart';

class SupervisorReportController {
  final Dio _dio = Dio();
  final String _baseUrl = 'http://preprod-orange.ernst.tn';

  Future<List<SupervisorReport>> fetchReport({
    required String token,
    required String from,
    required String to,
  }) async {
    try {
      print('From: $from');
      print('To: $to');

      final response = await _dio.get(
        '$_baseUrl/Main/Api/Sims/GetSupervisorReport',
        queryParameters: {
          'from': from,
          'to': to,
          'resultType': 4,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print('Response status code: ${response.statusCode}');
      print('Response data: ${response.data}');

      final data = response.data['Body']?['FieldUserSales'];

      if (data == null || data is! List) {
        print('No FieldUserSales data found');
        return [];
      }

      return data.map<SupervisorReport>((e) => SupervisorReport.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Erreur API: $e');
    }
  }
}
