import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ReportController extends GetxController {
  final String token;  // The token passed during initialization
  var isLoading = false.obs;
  var reportList = <AgentReport>[].obs;

  ReportController({required this.token});  // Constructor to pass the token

  // Function to fetch report data
  Future<void> fetchReport(String fromDate, String toDate) async {
    final url = Uri.parse('http://preprod-orange.ernst.tn/Main/Api/Sims/GetSupervisorReport');

    // API parameters
    final params = {
      'from': fromDate,
      'to': toDate,
      'resultType': '4',
    };

    // Log the request parameters
    debugPrint("Fetching report with parameters: $params");

    isLoading.value = true;

    try {
      // Log the token before sending the request
      debugPrint("Authorization token: $token");

      // Log the request URL
      debugPrint("Sending GET request to $url");

      final response = await http.get(
        url.replace(queryParameters: params),
        headers: {
          'Authorization': 'Bearer $token',  // Add token to headers
        },
      );

      // Log the response status and body
      debugPrint("Response status: ${response.statusCode}");
      debugPrint("Response body: ${response.body}");

      if (response.statusCode == 200) {
        // Parse the response body
        final data = json.decode(response.body);

        // Log the data fetched from the API
        debugPrint("Data fetched: ${data['data']}");

        // Assuming the response body contains a list of reports
        reportList.value = data['data'].map<AgentReport>((item) => AgentReport.fromJson(item)).toList();

        // Log the updated report list
        debugPrint("Updated report list: ${reportList.length} items");
      } else {
        // Handle API errors (status code != 200)
        Get.snackbar('Error', 'Failed to load report data');
        debugPrint("Failed to fetch report. Status code: ${response.statusCode}");
      }
    } catch (e) {
      // Handle any errors
      Get.snackbar('Error', 'Something went wrong: $e');
      debugPrint("Error occurred while fetching report: $e");
    } finally {
      isLoading.value = false;
    }
  }
}

// Example data model (adjust according to the actual API response structure)
class AgentReport {
  final String agentName;
  final int normalSales;
  final int portabilitySales;
  final int totalSales;

  AgentReport({
    required this.agentName,
    required this.normalSales,
    required this.portabilitySales,
    required this.totalSales,
  });

  factory AgentReport.fromJson(Map<String, dynamic> json) {
    return AgentReport(
      agentName: json['agentName'],
      normalSales: json['normalSales'],
      portabilitySales: json['portabilitySales'],
      totalSales: json['totalSales'],
    );
  }
}
