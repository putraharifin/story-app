// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Story App';

  @override
  String get loginTitle => 'Welcome back';

  @override
  String get loginSubtitle => 'Sign in to share your Dicoding moments';

  @override
  String get registerTitle => 'Create account';

  @override
  String get registerSubtitle => 'Register to start sharing your stories';

  @override
  String get name => 'Name';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get signIn => 'Sign In';

  @override
  String get register => 'Register';

  @override
  String get noAccountYet => 'No account yet? Register';

  @override
  String get haveAccount => 'Already have an account? Sign In';

  @override
  String get registerSuccess => 'Registration successful. Please sign in.';

  @override
  String get nameRequired => 'Name is required';

  @override
  String get emailRequired => 'Email is required';

  @override
  String get emailInvalid => 'Enter a valid email address';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get passwordMinLength => 'Password must be at least 8 characters';

  @override
  String get showPassword => 'Show password';

  @override
  String get hidePassword => 'Hide password';

  @override
  String get storiesTitle => 'Story';

  @override
  String get storyDetailTitle => 'Story Detail';

  @override
  String get addStoryTitle => 'New Story';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get description => 'Description';

  @override
  String get descriptionRequired => 'Description is required';

  @override
  String get upload => 'Upload';

  @override
  String get imageRequired => 'Please choose a photo first';

  @override
  String get imageTooLarge => 'Photo must be 1 MB or smaller';

  @override
  String get imagePickFailed => 'Unable to open the camera or gallery';

  @override
  String get uploadSuccess => 'Story uploaded successfully';

  @override
  String get logout => 'Logout';

  @override
  String get language => 'Language';

  @override
  String get retry => 'Try again';

  @override
  String get refresh => 'Refresh';

  @override
  String get emptyStories => 'No stories yet. Be the first to share one!';

  @override
  String get errorGeneric =>
      'Something went wrong. Check your connection and try again.';
}
