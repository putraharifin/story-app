import 'package:story_app/l10n/app_localizations.dart';

class Validators {
  const Validators._();

  static final RegExp _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  static String? name(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) return l10n.nameRequired;
    return null;
  }

  static String? email(String? value, AppLocalizations l10n) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return l10n.emailRequired;
    if (!_emailPattern.hasMatch(text)) return l10n.emailInvalid;
    return null;
  }

  static String? password(String? value, AppLocalizations l10n) {
    if (value == null || value.isEmpty) return l10n.passwordRequired;
    if (value.length < 8) return l10n.passwordMinLength;
    return null;
  }

  static String? description(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) return l10n.descriptionRequired;
    return null;
  }
}
