import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:story_app/core/error/app_exception.dart';
import 'package:story_app/core/utils/safe_change_notifier.dart';
import 'package:story_app/core/utils/view_state.dart';
import 'package:story_app/domain/entities/story.dart';
import 'package:story_app/domain/repositories/location_repository.dart';
import 'package:story_app/domain/repositories/story_repository.dart';

class StoryDetailProvider extends ChangeNotifier with SafeChangeNotifier {
  /// [initialStory] is the item tapped in the list. It lets the page (and the
  /// Hero animation) show content immediately while the detail is refreshed.
  StoryDetailProvider({
    required this._storyRepository,
    required this._locationRepository,
    Story? initialStory,
  }) : _story = initialStory,
       _state = initialStory == null ? ViewState.loading : ViewState.success;

  final StoryRepository _storyRepository;
  final LocationRepository _locationRepository;

  ViewState _state;
  Story? _story;
  String? _message;
  String? _storyId;
  String? _address;
  bool _isAddressLoading = false;
  bool _addressResolved = false;

  ViewState get state => _state;
  Story? get story => _story;
  String? get message => _message;
  String? get address => _address;
  bool get isAddressLoading => _isAddressLoading;

  Future<void> fetchDetail(String id) async {
    _storyId = id;
    final hasData = _story != null;

    if (hasData) {
      unawaited(loadAddress());
    } else {
      _state = ViewState.loading;
      notifyListeners();
    }

    try {
      _story = await _storyRepository.getStoryDetail(id);
      _message = null;
      _state = ViewState.success;
    } on ApiException catch (e) {
      if (!hasData) _setError(e.message);
    } on Exception {
      if (!hasData) _setError(null);
    }
    notifyListeners();

    await loadAddress();
  }

  Future<void> retry() {
    final id = _storyId;
    if (id == null) return Future.value();
    return fetchDetail(id);
  }

  Future<void> loadAddress() async {
    final location = _story?.location;
    if (location == null || _isAddressLoading || _addressResolved) return;

    _isAddressLoading = true;
    notifyListeners();

    _address = await _locationRepository.getAddress(location);
    _addressResolved = true;
    _isAddressLoading = false;
    notifyListeners();
  }

  void _setError(String? message) {
    _message = message;
    _state = ViewState.error;
  }
}
