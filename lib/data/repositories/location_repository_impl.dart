import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:story_app/domain/entities/geo_point.dart';
import 'package:story_app/domain/repositories/location_repository.dart';

class LocationRepositoryImpl implements LocationRepository {
  const LocationRepositoryImpl();

  @override
  Future<String?> getAddress(GeoPoint point) async {
    try {
      final placemarks = await Geocoding().placemarkFromCoordinates(
        point.latitude,
        point.longitude,
      );
      if (placemarks.isEmpty) return null;

      final place = placemarks.first;
      final parts = <String>[];
      for (final part in [
        place.street,
        place.subLocality,
        place.locality,
        place.subAdministrativeArea,
        place.administrativeArea,
        place.postalCode,
        place.country,
      ]) {
        if (part != null && part.isNotEmpty && !parts.contains(part)) {
          parts.add(part);
        }
      }
      return parts.isEmpty ? null : parts.join(', ');
    } on Exception {
      return null;
    }
  }

  @override
  Future<GeoPoint?> getCurrentLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return null;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 15),
        ),
      );
      return GeoPoint(
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } on Exception {
      return null;
    }
  }
}
