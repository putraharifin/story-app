import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:story_app/domain/entities/geo_point.dart';

part 'story.freezed.dart';

@freezed
abstract class Story with _$Story {
  const Story._();

  const factory Story({
    required String id,
    required String name,
    required String description,
    required String photoUrl,
    required DateTime createdAt,
    double? lat,
    double? lon,
  }) = _Story;

  GeoPoint? get location {
    final latitude = lat;
    final longitude = lon;
    if (latitude == null || longitude == null) return null;
    return GeoPoint(latitude: latitude, longitude: longitude);
  }
}
