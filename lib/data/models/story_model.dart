import 'package:story_app/domain/entities/story.dart';

class StoryModel extends Story {
  const StoryModel({
    required super.id,
    required super.name,
    required super.description,
    required super.photoUrl,
    required super.createdAt,
    super.lat,
    super.lon,
  });

  factory StoryModel.fromJson(Map<String, dynamic> json) {
    return StoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      photoUrl: json['photoUrl'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lat: (json['lat'] as num?)?.toDouble(),
      lon: (json['lon'] as num?)?.toDouble(),
    );
  }
}
