import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/domain/entities/geo_point.dart';
import 'package:story_app/domain/entities/story.dart';
import 'package:story_app/domain/repositories/location_repository.dart';
import 'package:story_app/domain/repositories/story_repository.dart';
import 'package:story_app/presentation/pages/add_story_page.dart';
import 'package:story_app/presentation/pages/login_page.dart';
import 'package:story_app/presentation/pages/pick_location_page.dart';
import 'package:story_app/presentation/pages/register_page.dart';
import 'package:story_app/presentation/pages/story_detail_page.dart';
import 'package:story_app/presentation/pages/story_list_page.dart';
import 'package:story_app/presentation/providers/add_story_provider.dart';
import 'package:story_app/presentation/providers/auth_provider.dart';
import 'package:story_app/presentation/providers/pick_location_provider.dart';
import 'package:story_app/presentation/providers/story_detail_provider.dart';
import 'package:story_app/presentation/providers/story_list_provider.dart';

class AppRoutes {
  const AppRoutes._();

  static const String login = '/login';
  static const String register = '/register';
  static const String stories = '/stories';
  static const String addStory = '/stories/add';
  static const String pickLocation = '/stories/add/location';

  static String storyDetail(String id) => '/stories/$id';
}

GoRouter createAppRouter(AuthProvider auth) {
  return GoRouter(
    initialLocation: AppRoutes.stories,
    refreshListenable: auth,
    redirect: (context, state) {
      final location = state.matchedLocation;
      final isAuthPage =
          location == AppRoutes.login || location == AppRoutes.register;

      if (!auth.isLoggedIn && !isAuthPage) return AppRoutes.login;
      if (auth.isLoggedIn && isAuthPage) return AppRoutes.stories;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.stories,
        builder: (context, state) => ChangeNotifierProvider(
          create: (context) =>
              StoryListProvider(context.read<StoryRepository>())
                ..fetchStories(),
          child: const StoryListPage(),
        ),
        routes: [
          GoRoute(
            path: 'add',
            builder: (context, state) => ChangeNotifierProvider(
              create: (context) =>
                  AddStoryProvider(context.read<StoryRepository>()),
              child: const AddStoryPage(),
            ),
            routes: [
              GoRoute(
                path: 'location',
                builder: (context, state) {
                  final extra = state.extra;
                  return ChangeNotifierProvider(
                    create: (context) => PickLocationProvider(
                      context.read<LocationRepository>(),
                      initial: extra is GeoPoint ? extra : null,
                    ),
                    child: const PickLocationPage(),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final extra = state.extra;
              return ChangeNotifierProvider(
                create: (context) => StoryDetailProvider(
                  storyRepository: context.read<StoryRepository>(),
                  locationRepository: context.read<LocationRepository>(),
                  initialStory: extra is Story ? extra : null,
                )..fetchDetail(state.pathParameters['id']!),
                child: const StoryDetailPage(),
              );
            },
          ),
        ],
      ),
    ],
  );
}
