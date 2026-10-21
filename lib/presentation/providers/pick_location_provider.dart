import 'package:flutter/foundation.dart';
import 'package:story_app/core/utils/safe_change_notifier.dart';
import 'package:story_app/domain/entities/geo_point.dart';
import 'package:story_app/domain/repositories/location_repository.dart';

class PickLocationProvider extends ChangeNotifier with SafeChangeNotifier {
  PickLocationProvider(this._repository, {GeoPoint? initial})
    : _selected = initial {
    if (initial != null) _loadAddress(initial);
  }

  final LocationRepository _repository;

  GeoPoint? _selected;
  String? _address;
  bool _isAddressLoading = false;
  bool _hasLocationAccess = false;
  bool _isLocating = false;
  int _addressRequest = 0;

  GeoPoint? get selected => _selected;
  String? get address => _address;
  bool get isAddressLoading => _isAddressLoading;
  bool get hasLocationAccess => _hasLocationAccess;

  Future<void> select(GeoPoint point) {
    _selected = point;
    _address = null;
    return _loadAddress(point);
  }

  /// Returns the device position, or null when it cannot be determined.
  Future<GeoPoint?> locateMe() async {
    if (_isLocating) return null;
    _isLocating = true;

    final point = await _repository.getCurrentLocation();

    _isLocating = false;
    if (point != null) {
      _hasLocationAccess = true;
      notifyListeners();
    }
    return point;
  }

  Future<void> _loadAddress(GeoPoint point) async {
    final request = ++_addressRequest;
    _isAddressLoading = true;
    notifyListeners();

    final address = await _repository.getAddress(point);
    if (request != _addressRequest) return;

    _address = address;
    _isAddressLoading = false;
    notifyListeners();
  }
}
