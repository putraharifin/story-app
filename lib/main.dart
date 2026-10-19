import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/app.dart';
import 'package:story_app/core/network/api_client.dart';
import 'package:story_app/data/datasources/auth_local_data_source.dart';
import 'package:story_app/data/datasources/auth_remote_data_source.dart';
import 'package:story_app/data/datasources/story_remote_data_source.dart';
import 'package:story_app/data/repositories/auth_repository_impl.dart';
import 'package:story_app/data/repositories/story_repository_impl.dart';
import 'package:story_app/domain/repositories/auth_repository.dart';
import 'package:story_app/domain/repositories/story_repository.dart';
import 'package:story_app/presentation/providers/auth_provider.dart';
import 'package:story_app/presentation/providers/locale_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final apiClient = ApiClient();
  final localDataSource = AuthLocalDataSource(prefs);

  final AuthRepository authRepository = AuthRepositoryImpl(
    remote: AuthRemoteDataSource(apiClient),
    local: localDataSource,
  );
  final StoryRepository storyRepository = StoryRepositoryImpl(
    remote: StoryRemoteDataSource(apiClient),
    local: localDataSource,
  );

  runApp(
    MultiProvider(
      providers: [
        Provider<StoryRepository>.value(value: storyRepository),
        ChangeNotifierProvider(create: (_) => AuthProvider(authRepository)),
        ChangeNotifierProvider(create: (_) => LocaleProvider(prefs)),
      ],
      child: const StoryApp(),
    ),
  );
}
