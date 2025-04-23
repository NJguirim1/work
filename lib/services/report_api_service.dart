import 'dart:convert';
import 'package:http/http.dart' as http;

class ReportApiService {
  final String baseUrl = "http://preprod-orange.ernst.tn/";

  Future<http.Response> getSupervisorReport({
    required String token,
    required String from,
    required String to,
    int resultType = 4,
  }) async {
    final uri = Uri.parse(
      "${baseUrl}Main/Api/Sims/GetSupervisorReport?from=$from&to=$to&resultType=$resultType",
    );

    final response = await http.get(
      uri,
      headers: {
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      },
    );

    return response;
  }
}
