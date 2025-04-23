import 'package:get/get.dart';
import '../models/stat_model.dart';
import '../services/api_service.dart';

class StatsController extends GetxController {
  var statsList = <StatModel>[].obs;
  var isLoading = false.obs;

  Future<void> getStats(String token, String username, String from, String to, String saleType) async {
    try {
      isLoading.value = true;
      final result = await ApiService.fetchStats(
        token: token,
        username: username,
        from: from,
        to: to,
        saleType: saleType,
      );
      statsList.assignAll(result);
    } catch (e) {
      print("Erreur: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
