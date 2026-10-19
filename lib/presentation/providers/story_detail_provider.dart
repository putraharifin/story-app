import 'package:flutter/foundation.dart';
import 'package:story_app/core/error/app_exception.dart';
import 'package:story_app/core/utils/view_state.dart';
import 'package:story_app/domain/entities/story.dart';
import 'package:story_app/domain/repositories/story_repository.dart';

class StoryDetailProvider extends ChangeNotifier {
  StoryDetailProvider(this._repository);

  final StoryRepository _repository;

  ViewState _state = ViewState.loading;
  Story? _story;
  String? _message;
  String? _storyId;

  ViewState get state => _state;
  Story? get story => _story;
  String? get message => _message;

  Future<void> fetchDetail(String id) async {
    _storyId = id;
    _state = ViewState.loading;
    notifyListeners();

    try {
      _story = await _repository.getStoryDetail(id);
      _message = null;
      _state = ViewState.success;
    } on ApiException catch (e) {
      _message = e.message;
      _state = ViewState.error;
    } on Exception {
      _message = null;
      _state = ViewState.error;
    }
    notifyListeners();
  }

  Future<void> retry() {
    final id = _storyId;
    if (id == null) return Future.value();
    return fetchDetail(id);
  }
}
