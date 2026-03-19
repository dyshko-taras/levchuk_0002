import 'package:FlutterApp/constants/app_routes.dart';
import 'package:FlutterApp/ui/pages/add_exercise_page.dart';
import 'package:FlutterApp/ui/pages/breathing_settings_page.dart';
import 'package:FlutterApp/ui/pages/custom_step_page.dart';
import 'package:FlutterApp/ui/pages/exercise_page.dart';
import 'package:FlutterApp/ui/pages/shell/breathing_page.dart';
import 'package:FlutterApp/ui/pages/shell/home_page.dart';
import 'package:FlutterApp/ui/pages/shell/main_shell_page.dart';
import 'package:FlutterApp/ui/pages/shell/quotes_page.dart';
import 'package:FlutterApp/ui/pages/shell/settings_page.dart';
import 'package:FlutterApp/ui/pages/shell/tips_page.dart';
import 'package:FlutterApp/ui/pages/shell/workout_page.dart';
import 'package:FlutterApp/ui/pages/splash_page.dart';
import 'package:FlutterApp/ui/pages/tip_detail_page.dart';
import 'package:FlutterApp/ui/pages/welcome_page.dart';
import 'package:FlutterApp/ui/pages/workout_session_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _homeNavigatorKey = GlobalKey<NavigatorState>();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, _) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.welcome,
        builder: (_, _) => const WelcomePage(),
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
                builder: (_, _) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.tips,
                builder: (_, _) => const TipsPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.breathe,
                builder: (_, _) => const BreathingPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.quotes,
                builder: (_, _) => const QuotesPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.workout,
                builder: (_, _) => const WorkoutPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                builder: (_, _) => const SettingsPage(),
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
        builder: (_, _) => const AddExercisePage(),
      ),
      GoRoute(
        path: AppRoutes.customStep,
        builder: (_, _) => const CustomStepPage(),
      ),
      GoRoute(
        path: '${AppRoutes.tips}/:topicId',
        builder: (_, state) =>
            TipDetailPage(topicId: state.pathParameters['topicId'] ?? ''),
      ),
      GoRoute(
        path: AppRoutes.breathingSettings,
        builder: (_, _) => const BreathingSettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.workoutSession,
        builder: (_, _) => const WorkoutSessionPage(),
      ),
    ],
  );
}
