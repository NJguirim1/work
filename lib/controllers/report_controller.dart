import 'dart:convert';
import 'package:get/get.dart';
import '../models/report_model.dart';
import '../services/api_service.dart';

class ReportController extends GetxController {
  var reports = <Report>[].obs;
  var isLoading = false.obs;
  final ApiService _apiService = ApiService();

  Future<void> fetchReports(String token, String from, String to) async {
    try {
      isLoading(true);
      final response = await _apiService.getSupervisorReport(
        token: token,
        from: from,
        to: to,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        reports.value = data.map((e) => Report.fromJson(e)).toList();
      } else {
        Get.snackbar('Error', 'Failed to load report');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
