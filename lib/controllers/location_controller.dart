import 'package:get/get.dart';
import 'package:location/location.dart';

class LocationController extends GetxController {
  final RxBool isAccessingLocation = false.obs;
  final RxString errorDescription = "".obs;
  final Rx<LocationData?> userLocation = Rx<LocationData?>(null);

  // Update the location access status
  void updateIsAccessingLocation(bool value) {
    print('Updating accessing location status: $value');
    isAccessingLocation.value = value;
  }

  // Update the user's location
  void updateUserLocation(LocationData? data) {
    if (data != null && data.latitude != null && data.longitude != null) {
      print('Updating user location: ${data.latitude}, ${data.longitude}');
      userLocation.value = data;
      errorDescription.value = ""; // Clear any previous errors
    } else {
      print('Invalid location data received.');
      errorDescription.value = "Invalid location data.";
    }
  }
}