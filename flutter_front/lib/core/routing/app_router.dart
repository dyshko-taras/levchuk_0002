import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../constants/app_routes.dart';
import '../../ui/pages/add_exercise_page.dart';
import '../../ui/pages/breathing_page.dart';
import '../../ui/pages/breathing_settings_page.dart';
import '../../ui/pages/custom_step_page.dart';
import '../../ui/pages/exercise_page.dart';
import '../../ui/pages/quotes_page.dart';
import '../../ui/pages/settings_page.dart';
import '../../ui/pages/tip_detail_page.dart';
import '../../ui/pages/tips_page.dart';
import '../../ui/pages/workout_page.dart';
import '../../ui/pages/workout_session_page.dart';
import '../../ui/pages/shell/home_page.dart';
import '../../ui/pages/shell/main_shell_page.dart';
import '../../ui/pages/splash_page.dart';
import '../../ui/pages/welcome_page.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _homeNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, __) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (_, __) => const WelcomePage(),
      ),
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state, navigationShell) =>
            MainShellPage(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: _homeNavigatorKey,
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (_, __) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.tips,
                builder: (_, __) => const TipsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.breathe,
                builder: (_, __) => const BreathingPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.quotes,
                builder: (_, __) => const QuotesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.workout,
                builder: (_, __) => const WorkoutPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (_, __) => const SettingsPage(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '${AppRoutes.exercise}/:hour',
        builder: (_, state) => ExercisePage(
          hour: int.tryParse(state.pathParameters['hour'] ?? '') ?? 1,
        ),
      ),
      GoRoute(
        path: AppRoutes.addExercise,
        builder: (_, __) => const AddExercisePage(),
      ),
      GoRoute(
        path: AppRoutes.customStep,
        builder: (_, __) => const CustomStepPage(),
      ),
      GoRoute(
        path: '${AppRoutes.tips}/:topicId',
        builder: (_, state) =>
            TipDetailPage(topicId: state.pathParameters['topicId'] ?? ''),
      ),
      GoRoute(
        path: AppRoutes.breathingSettings,
        builder: (_, __) => const BreathingSettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.workoutSession,
        builder: (_, __) => const WorkoutSessionPage(),
      ),
    ],
  );
}
