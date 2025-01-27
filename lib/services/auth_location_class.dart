import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class AuthLocationClass {
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print("Location services are disabled.");
      // Show a dialog or a prompt to enable location services
       await Geolocator.openLocationSettings();
      return null;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print("Location permissions are denied.");
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print("Location permissions are permanently denied.");
      // Prompt user to open app settings and allow location permission
      openAppSettings();
      return null;
    }

    // Get current location
    try {
      Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
      );
      print("Location: ${position.latitude}, ${position.longitude}");
      return position;
    } catch (e) {
      print("Failed to get location: $e");
      return null;
    }
  }
}
