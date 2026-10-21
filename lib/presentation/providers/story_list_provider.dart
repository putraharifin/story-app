import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:story_app/core/constants/api_constants.dart';
import 'package:story_app/core/error/app_exception.dart';
import 'package:story_app/core/utils/safe_change_notifier.dart';
import 'package:story_app/core/utils/view_state.dart';
import 'package:story_app/domain/entities/story.dart';
import 'package:story_app/domain/repositories/story_repository.dart';

class StoryListProvider extends ChangeNotifier with SafeChangeNotifier {
  StoryListProvider(this._repository);

  final StoryRepository _repository;
  final List<Story> _stories = [];

  ViewState _state = ViewState.loading;
  String? _message;
  int _nextPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;
  bool _loadMoreFailed = false;

  /// Incremented on every refresh so responses of an outdated request
  /// are ignored instead of being mixed into the new list.
  int _generation = 0;

  ViewState get state => _state;
  String? get message => _message;
  List<Story> get stories => UnmodifiableListView(_stories);
  bool get loadMoreFailed => _loadMoreFailed;
  bool get showFooter => _hasMore || _loadMoreFailed;

  /// Loads the first page. When [silent] is true the current list stays
  /// visible while refreshing (pull-to-refresh and after uploading a story).
  Future<void> fetchStories({bool silent = false}) async {
    final generation = ++_generation;
    _isLoadingMore = false;
    _loadMoreFailed = false;

    if (!silent) {
      _state = ViewState.loading;
      notifyListeners();
    }

    try {
      final result = await _repository.getStories(
        page: 1,
        size: ApiConstants.pageSize,
      );
      if (generation != _generation) return;

      final knownIds = <String>{};
      _stories
        ..clear()
        ..addAll(result.where((story) => knownIds.add(story.id)));
      _nextPage = 2;
      _hasMore = result.length >= ApiConstants.pageSize;
      _message = null;
      _state = _stories.isEmpty ? ViewState.empty : ViewState.success;
    } on ApiException catch (e) {
      if (generation != _generation) return;
      _message = e.message;
      _state = ViewState.error;
    } on Exception {
      if (generation != _generation) return;
      _message = null;
      _state = ViewState.error;
    }
    notifyListeners();
  }

  Future<void> fetchNextPage() async {
    if (_state != ViewState.success || !_hasMore || _isLoadingMore) return;

    final generation = _generation;
    _isLoadingMore = true;
    _loadMoreFailed = false;
    notifyListeners();

    try {
      final result = await _repository.getStories(
        page: _nextPage,
        size: ApiConstants.pageSize,
      );
      if (generation != _generation) return;

      final knownIds = _stories.map((story) => story.id).toSet();
      _stories.addAll(result.where((story) => knownIds.add(story.id)));
      _nextPage++;
      _hasMore = result.length >= ApiConstants.pageSize;
    } on Exception {
      if (generation != _generation) return;
      _loadMoreFailed = true;
    }
    _isLoadingMore = false;
    notifyListeners();
  }
}
