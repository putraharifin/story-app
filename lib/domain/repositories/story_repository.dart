import 'dart:io';

import 'package:story_app/domain/entities/story.dart';

abstract class StoryRepository {
  Future<List<Story>> getStories();

  Future<Story> getStoryDetail(String id);

  Future<void> addStory({required String description, required File photo});
}
