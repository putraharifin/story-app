import 'package:flutter/services.dart' show appFlavor;

/// Reads the build flavor passed with `--flavor free|paid`.
/// Runs without a flavor fall back to the free behaviour.
class AppFlavor {
  const AppFlavor._();

  static const String free = 'free';
  static const String paid = 'paid';

  static bool get isPaid => appFlavor == paid;
}
