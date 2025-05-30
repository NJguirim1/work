import 'package:flutter_application_1/controllers/location_controller.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart' as handler;

class LocationService {
  LocationService._init();
  static final LocationService instance = LocationService._init();

  final Location _location = Location();

  // Check if location services are enabled
  Future<bool> checkForServiceAvailability() async {
    bool isEnabled = await _location.serviceEnabled();
    if (!isEnabled) {
      isEnabled = await _location.requestService();
      if (!isEnabled) {
        return false; // Service is still not enabled
      }
    }
    return true;
  }

  // Check and request location permissions
  Future<bool> checkForPermission() async {
    PermissionStatus status = await _location.hasPermission();
    if (status == PermissionStatus.denied) {
      status = await _location.requestPermission();
      if (status != PermissionStatus.granted) {
        return false; // Permission not granted
      }
    }

    if (status == PermissionStatus.deniedForever) {
      // Open app settings if permission is permanently denied
      Get.snackbar(
        "Permission Needed",
        "We need location permission to provide better services.",
        onTap: (snack) => handler.openAppSettings(),
      ).show();
      return false;
    }

    return true; // Permission granted
  }

  // Fetch user location
  Future<void> getUserLocation({required LocationController controller}) async {
    controller.updateIsAccessingLocation(true);

    try {
      // Check if location services are available
      if (!await checkForServiceAvailability()) {
        controller.errorDescription.value = "Location services are not enabled.";
        return;
      }

      // Check if location permissions are granted
      if (!await checkForPermission()) {
        controller.errorDescription.value = "Location permissions are not granted.";
        return;
      }

      // Fetch location data
      final LocationData data = await _location.getLocation();
      if (data.latitude == null || data.longitude == null) {
        throw Exception("Invalid location data received.");
      }

      // Update location in the controller
      controller.updateUserLocation(data);
    } catch (e) {
      controller.errorDescription.value = "Failed to fetch location: $e";
    } finally {
      controller.updateIsAccessingLocation(false);
    }
  }
}