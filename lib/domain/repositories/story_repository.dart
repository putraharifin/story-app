import 'dart:io';

import 'package:story_app/domain/entities/geo_point.dart';
import 'package:story_app/domain/entities/story.dart';

abstract class StoryRepository {
  Future<List<Story>> getStories({required int page, required int size});

  Future<Story> getStoryDetail(String id);

  Future<void> addStory({
    required String description,
    required File photo,
    GeoPoint? location,
  });
}
