import 'dart:io';

import 'package:story_app/core/error/app_exception.dart';
import 'package:story_app/data/datasources/auth_local_data_source.dart';
import 'package:story_app/data/datasources/story_remote_data_source.dart';
import 'package:story_app/domain/entities/story.dart';
import 'package:story_app/domain/repositories/story_repository.dart';

class StoryRepositoryImpl implements StoryRepository {
  const StoryRepositoryImpl({
    required StoryRemoteDataSource remote,
    required AuthLocalDataSource local,
  })  : _remote = remote,
        _local = local;

  final StoryRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  String get _token {
    final session = _local.getSession();
    if (session == null) throw const ApiException();
    return session.token;
  }

  @override
  Future<List<Story>> getStories() async {
    final stories = await _remote.getStories(_token);
    return [...stories]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  @override
  Future<Story> getStoryDetail(String id) {
    return _remote.getStoryDetail(id, _token);
  }

  @override
  Future<void> addStory({required String description, required File photo}) {
    return _remote.addStory(
      description: description,
      photo: photo,
      token: _token,
    );
  }
}
