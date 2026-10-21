import 'dart:io';

import 'package:story_app/core/network/api_client.dart';
import 'package:story_app/data/models/story_model.dart';

class StoryRemoteDataSource {
  const StoryRemoteDataSource(this._client);

  final ApiClient _client;

  Future<List<StoryModel>> getStories({
    required int page,
    required int size,
    required String token,
  }) async {
    final body = await _client.get(
      '/stories?page=$page&size=$size&location=0',
      token: token,
    );
    final list = body['listStory'] as List<dynamic>? ?? [];
    return list
        .map((item) => StoryModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<StoryModel> getStoryDetail(String id, String token) async {
    final body = await _client.get('/stories/$id', token: token);
    return StoryModel.fromJson(body['story'] as Map<String, dynamic>);
  }

  Future<void> addStory({
    required String description,
    required File photo,
    required String token,
    double? lat,
    double? lon,
  }) async {
    await _client.postMultipart(
      '/stories',
      fields: {
        'description': description,
        if (lat != null && lon != null) ...{
          'lat': lat.toString(),
          'lon': lon.toString(),
        },
      },
      fileField: 'photo',
      file: photo,
      token: token,
    );
  }
}
