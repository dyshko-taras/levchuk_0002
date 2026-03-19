import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/routing/app_router.dart';
import 'data/repositories/breathing_settings_repository.dart';
import 'data/repositories/exercise_repository.dart';
import 'data/repositories/progress_repository.dart';
import 'data/repositories/quotes_repository.dart';
import 'data/repositories/tips_repository.dart';
import 'data/repositories/workout_repository.dart';
import 'providers/app_bootstrap_provider.dart';
import 'providers/breathing_provider.dart';
import 'providers/quotes_provider.dart';
import 'providers/routine_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/shell_navigation_provider.dart';
import 'providers/tips_provider.dart';
import 'providers/workout_provider.dart';
import 'ui/theme/app_theme.dart';

class ActiveOfficeApp extends StatelessWidget {
  const ActiveOfficeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => ExerciseRepository()),
        Provider(create: (_) => ProgressRepository()),
        Provider(create: (_) => QuotesRepository()),
        Provider(create: (_) => TipsRepository()),
        Provider(create: (_) => WorkoutRepository()),
        Provider(create: (_) => BreathingSettingsRepository()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()..load()),
        ChangeNotifierProvider(
          create: (_) => AppBootstrapProvider()..initialize(),
        ),
        ChangeNotifierProvider(create: (_) => ShellNavigationProvider()),
        ChangeNotifierProvider(
          create: (context) => RoutineProvider(
            exerciseRepository: context.read<ExerciseRepository>(),
            progressRepository: context.read<ProgressRepository>(),
          )..load(),
        ),
        ChangeNotifierProvider(
          create: (context) => QuotesProvider(
            quotesRepository: context.read<QuotesRepository>(),
          )..load(),
        ),
        ChangeNotifierProvider(
          create: (context) => TipsProvider(
            tipsRepository: context.read<TipsRepository>(),
          )..load(),
        ),
        ChangeNotifierProvider(
          create: (context) => BreathingProvider(
            repository: context.read<BreathingSettingsRepository>(),
            routineProvider: context.read<RoutineProvider>(),
          )..load(),
        ),
        ChangeNotifierProvider(
          create: (context) => WorkoutProvider(
            workoutRepository: context.read<WorkoutRepository>(),
            exerciseRepository: context.read<ExerciseRepository>(),
            routineProvider: context.read<RoutineProvider>(),
          )..load(),
        ),
      ],
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        title: 'ActiveOffice',
        theme: AppTheme.dark,
        routerConfig: AppRouter.router,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
      ),
    );
  }
}
