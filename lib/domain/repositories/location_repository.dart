import 'package:story_app/domain/entities/geo_point.dart';

abstract class LocationRepository {
  /// Human readable address for [point], or null when it cannot be resolved.
  Future<String?> getAddress(GeoPoint point);

  /// Current device position, or null when GPS/permission is unavailable.
  Future<GeoPoint?> getCurrentLocation();
}
