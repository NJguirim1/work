import 'package:flutter_application_1/services/api_service.dart' as ApiService;
import 'package:get/get.dart';
import '../models/stat_model.dart';

class StatsController extends GetxController {
  var statsList = <StatModel>[].obs;
  var isLoading = false.obs;

  Future<void> getStats(String token, String username, String from, String to, String saleType) async {
    try {
      isLoading.value = true;
      statsList.clear();

      print("=== [STATS DEBUG] ===");
      print("Username: $username");
      print("From: $from");
      print("To: $to");
      print("SaleType: $saleType");
      print("=====================");

      final List<StatModel> stats = await ApiService.fetchStats(
        token: token,
        username: username,
        from: from,
        to: to,
        saleType: saleType,
      );

      print(">> Réponse API reçue. Nombre de stats: ${stats.length}");

      if (stats.isEmpty) {
        print(">> Aucune statistique trouvée.");
      }

      statsList.addAll(stats);
    } catch (e) {
      print(">> ERREUR getStats: $e");
      Get.snackbar("Erreur", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
