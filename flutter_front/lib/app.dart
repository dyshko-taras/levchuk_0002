import 'dart:async';

import 'package:FlutterApp/constants/app_routes.dart';
import 'package:FlutterApp/core/routing/app_router.dart';
import 'package:FlutterApp/data/repositories/breathing_settings_repository.dart';
import 'package:FlutterApp/data/repositories/exercise_repository.dart';
import 'package:FlutterApp/data/repositories/progress_repository.dart';
import 'package:FlutterApp/data/repositories/quotes_repository.dart';
import 'package:FlutterApp/data/repositories/tips_repository.dart';
import 'package:FlutterApp/data/repositories/workout_repository.dart';
import 'package:FlutterApp/providers/app_bootstrap_provider.dart';
import 'package:FlutterApp/providers/breathing_provider.dart';
import 'package:FlutterApp/providers/quotes_provider.dart';
import 'package:FlutterApp/providers/routine_provider.dart';
import 'package:FlutterApp/providers/settings_provider.dart';
import 'package:FlutterApp/providers/shell_navigation_provider.dart';
import 'package:FlutterApp/providers/tips_provider.dart';
import 'package:FlutterApp/providers/workout_provider.dart';
import 'package:FlutterApp/services/notification_service.dart';
import 'package:FlutterApp/ui/theme/app_theme.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActiveOfficeApp extends StatelessWidget {
  const ActiveOfficeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider.value(value: NotificationService.instance),
        Provider(create: (_) => ExerciseRepository()),
        Provider(create: (_) => ProgressRepository()),
        Provider(create: (_) => QuotesRepository()),
        Provider(create: (_) => TipsRepository()),
        Provider(create: (_) => WorkoutRepository()),
        Provider(create: (_) => BreathingSettingsRepository()),
        ChangeNotifierProvider(
          create: (context) {
            final provider = SettingsProvider(
              notificationService: context.read<NotificationService>(),
            );
            unawaited(provider.load());
            return provider;
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            final provider = AppBootstrapProvider();
            unawaited(provider.initialize());
            return provider;
          },
        ),
        ChangeNotifierProvider(create: (_) => ShellNavigationProvider()),
        ChangeNotifierProvider(
          create: (context) {
            final provider = RoutineProvider(
              exerciseRepository: context.read<ExerciseRepository>(),
              progressRepository: context.read<ProgressRepository>(),
            );
            unawaited(provider.load());
            return provider;
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            final provider = QuotesProvider(
              quotesRepository: context.read<QuotesRepository>(),
            );
            unawaited(provider.load());
            return provider;
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            final provider = TipsProvider(
              tipsRepository: context.read<TipsRepository>(),
            );
            unawaited(provider.load());
            return provider;
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            final provider = BreathingProvider(
              repository: context.read<BreathingSettingsRepository>(),
              routineProvider: context.read<RoutineProvider>(),
            );
            unawaited(provider.load());
            return provider;
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            final provider = WorkoutProvider(
              workoutRepository: context.read<WorkoutRepository>(),
              exerciseRepository: context.read<ExerciseRepository>(),
              routineProvider: context.read<RoutineProvider>(),
            );
            unawaited(provider.load());
            return provider;
          },
        ),
      ],
      child: const _AppShell(),
    );
  }
}

class _AppShell extends StatefulWidget {
  const _AppShell();

  @override
  State<_AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<_AppShell> with WidgetsBindingObserver {
  StreamSubscription<String>? _notificationSubscription;
  bool _demoStateSynced = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _notificationSubscription ??= context
        .read<NotificationService>()
        .payloadStream
        .listen(_handleNotificationPayload);

    final pendingPayload = context
        .read<NotificationService>()
        .consumePendingPayload();
    if (pendingPayload != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        unawaited(_handleNotificationPayload(pendingPayload));
      });
    }

    if (!_demoStateSynced) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        unawaited(_syncDemoDataState());
      });
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(_syncDemoDataState());
      unawaited(
        context.read<SettingsProvider>().refreshNotificationPermissionState(
          syncSchedules: true,
        ),
      );
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.hidden) {}
  }

  Future<void> _syncDemoDataState() async {
    final settings = context.read<SettingsProvider>();
    final routineProvider = context.read<RoutineProvider>();
    final workoutProvider = context.read<WorkoutProvider>();

    if (!settings.loaded ||
        !routineProvider.loaded ||
        !workoutProvider.loaded) {
      return;
    }

    _demoStateSynced = true;

    if (settings.demoDataEnabled) {
      if (routineProvider.userProgress.dailyProgress.isEmpty) {
        await routineProvider.applyDemoData();
      }
      if (workoutProvider.savedWorkouts.isEmpty && !workoutProvider.hasDraft) {
        await workoutProvider.applyDemoData();
      }
    }
  }

  Future<void> _handleNotificationPayload(String payload) async {
    if (payload.startsWith('exercise:')) {
      final rawHour = int.tryParse(payload.split(':').last) ?? 9;
      final routineHour = (rawHour - 8).clamp(1, 8);
      unawaited(AppRouter.router.push(AppRoutes.exerciseForHour(routineHour)));
      return;
    }

    if (payload == NotificationService.payloadBreathing) {
      await context.read<BreathingProvider>().applyReminderPreset();
      AppRouter.router.go(AppRoutes.breathe);
    }
  }

  @override
  void dispose() {
    unawaited(_notificationSubscription?.cancel());
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'ActiveOffice',
      theme: AppTheme.dark,
      routerConfig: AppRouter.router,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
    );
  }
}
