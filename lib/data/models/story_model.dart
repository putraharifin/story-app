import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:story_app/domain/entities/story.dart';

part 'story_model.freezed.dart';
part 'story_model.g.dart';

@freezed
abstract class StoryModel with _$StoryModel {
  const StoryModel._();

  const factory StoryModel({
    required String id,
    required String name,
    required String description,
    required String photoUrl,
    required DateTime createdAt,
    double? lat,
    double? lon,
  }) = _StoryModel;

  factory StoryModel.fromJson(Map<String, dynamic> json) =>
      _$StoryModelFromJson(json);

  Story toEntity() {
    return Story(
      id: id,
      name: name,
      description: description,
      photoUrl: photoUrl,
      createdAt: createdAt,
      lat: lat,
      lon: lon,
    );
  }
}
