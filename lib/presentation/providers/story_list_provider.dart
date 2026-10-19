import 'package:flutter/foundation.dart';
import 'package:story_app/core/error/app_exception.dart';
import 'package:story_app/core/utils/view_state.dart';
import 'package:story_app/domain/entities/story.dart';
import 'package:story_app/domain/repositories/story_repository.dart';

class StoryListProvider extends ChangeNotifier {
  StoryListProvider(this._repository);

  final StoryRepository _repository;

  ViewState _state = ViewState.loading;
  List<Story> _stories = const [];
  String? _message;

  ViewState get state => _state;
  List<Story> get stories => _stories;
  String? get message => _message;

  /// When [silent] is true the current content stays visible while refreshing
  /// (used by pull-to-refresh and after uploading a story).
  Future<void> fetchStories({bool silent = false}) async {
    if (!silent) {
      _state = ViewState.loading;
      notifyListeners();
    }

    try {
      _stories = await _repository.getStories();
      _message = null;
      _state = _stories.isEmpty ? ViewState.empty : ViewState.success;
    } on ApiException catch (e) {
      _message = e.message;
      _state = ViewState.error;
    } on Exception {
      _message = null;
      _state = ViewState.error;
    }
    notifyListeners();
  }
}
