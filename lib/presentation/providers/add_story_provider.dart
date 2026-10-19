import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_app/core/constants/api_constants.dart';
import 'package:story_app/core/error/app_exception.dart';
import 'package:story_app/domain/repositories/story_repository.dart';

enum PickResult { picked, cancelled, tooLarge, failed }

class AddStoryProvider extends ChangeNotifier {
  AddStoryProvider(this._repository, {ImagePicker? picker})
      : _picker = picker ?? ImagePicker();

  final StoryRepository _repository;
  final ImagePicker _picker;

  File? _image;
  bool _isUploading = false;
  String? _errorMessage;

  File? get image => _image;
  bool get isUploading => _isUploading;
  String? get errorMessage => _errorMessage;

  Future<PickResult> pickImage(ImageSource source) async {
    try {
      final picked = await _picker.pickImage(
        source: source,
        maxWidth: 1280,
        imageQuality: 70,
      );
      if (picked == null) return PickResult.cancelled;

      final file = File(picked.path);
      if (await file.length() > ApiConstants.maxImageBytes) {
        return PickResult.tooLarge;
      }

      _image = file;
      notifyListeners();
      return PickResult.picked;
    } on Exception {
      return PickResult.failed;
    }
  }

  Future<bool> upload(String description) async {
    final photo = _image;
    if (photo == null) return false;

    _isUploading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.addStory(description: description, photo: photo);
      return true;
    } on ApiException catch (e) {
      _errorMessage = e.message;
      return false;
    } on Exception {
      return false;
    } finally {
      _isUploading = false;
      notifyListeners();
    }
  }
}
