import 'package:flutter_application_1/models/PointageModel.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class PointageController extends GetxController {
  var pointages = <Pointage>[].obs;
  var isLoading = false.obs;

  Future<void> fetchPointages(String idAgent, String dateSelect) async {
    isLoading.value = true;

    final url = Uri.parse("http://preprod-orange.ernst.tn/Main/Api/Pointage/GetPointageByIdAgent?IdAgent=$idAgent&DateSelect=$dateSelect");
    final response = await http.get(url, headers: {
      "Authorization": "'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJJZCI6IjEwMDciLCJOYW1lIjoidGVycmFpbiogdGVycmFpbiIsIlVzZXJuYW1lIjoidGVycmFpbiIsIlR5cGUiOiJGaWVsZEFnZW50IiwibmJmIjoxNzM5OTAzNDgzLCJleHAiOjE3Mzk5MDcwODMsImlhdCI6MTczOTkwMzQ4MywiaXNzIjoiSXNzdWVyIiwiYXVkIjoiQXVkaWVuY2UifQ.6GwWfbQRThy0b2qMeri_3bZBj31la-Ag2mFJB-Vz6Hg'",
    });

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      pointages.value = data.map((json) => Pointage.fromJson(json)).toList();
    } else {
      Get.snackbar("Erreur", "Impossible de charger les pointages");
    }

    isLoading.value = false;
  }
}
