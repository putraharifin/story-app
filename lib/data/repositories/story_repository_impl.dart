import 'dart:io';

import 'package:story_app/core/error/app_exception.dart';
import 'package:story_app/data/datasources/auth_local_data_source.dart';
import 'package:story_app/data/datasources/story_remote_data_source.dart';
import 'package:story_app/domain/entities/geo_point.dart';
import 'package:story_app/domain/entities/story.dart';
import 'package:story_app/domain/repositories/story_repository.dart';

class StoryRepositoryImpl implements StoryRepository {
  const StoryRepositoryImpl({required this._remote, required this._local});

  final StoryRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  String get _token {
    final session = _local.getSession();
    if (session == null) throw const ApiException();
    return session.token;
  }

  @override
  Future<List<Story>> getStories({required int page, required int size}) async {
    final models = await _remote.getStories(
      page: page,
      size: size,
      token: _token,
    );
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Story> getStoryDetail(String id) async {
    final model = await _remote.getStoryDetail(id, _token);
    return model.toEntity();
  }

  @override
  Future<void> addStory({
    required String description,
    required File photo,
    GeoPoint? location,
  }) {
    return _remote.addStory(
      description: description,
      photo: photo,
      token: _token,
      lat: location?.latitude,
      lon: location?.longitude,
    );
  }
}
