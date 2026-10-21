import 'package:freezed_annotation/freezed_annotation.dart';

part 'geo_point.freezed.dart';

@freezed
abstract class GeoPoint with _$GeoPoint {
  const GeoPoint._();

  const factory GeoPoint({
    required double latitude,
    required double longitude,
  }) = _GeoPoint;

  String get coordinates =>
      '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}';
}
