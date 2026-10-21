import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:story_app/core/config/app_flavor.dart';
import 'package:story_app/core/constants/api_constants.dart';
import 'package:story_app/core/error/app_exception.dart';
import 'package:story_app/core/utils/safe_change_notifier.dart';
import 'package:story_app/domain/entities/geo_point.dart';
import 'package:story_app/domain/repositories/story_repository.dart';

enum PickResult { picked, cancelled, tooLarge, failed }

class AddStoryProvider extends ChangeNotifier with SafeChangeNotifier {
  AddStoryProvider(this._repository, {ImagePicker? picker})
    : _picker = picker ?? ImagePicker();

  final StoryRepository _repository;
  final ImagePicker _picker;

  File? _image;
  GeoPoint? _location;
  bool _isUploading = false;
  String? _errorMessage;

  File? get image => _image;
  GeoPoint? get location => _location;
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

  void setLocation(GeoPoint? location) {
    _location = location;
    notifyListeners();
  }

  Future<bool> upload(String description) async {
    final photo = _image;
    if (photo == null) return false;

    _isUploading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.addStory(
        description: description,
        photo: photo,
        location: AppFlavor.isPaid ? _location : null,
      );
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
