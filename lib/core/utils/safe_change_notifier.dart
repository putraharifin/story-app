import 'package:flutter/foundation.dart';

/// Ignores notifications that arrive after the notifier has been disposed,
/// e.g. when a request finishes after the user already left the page.
mixin SafeChangeNotifier on ChangeNotifier {
  bool _isDisposed = false;

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) super.notifyListeners();
  }
}
