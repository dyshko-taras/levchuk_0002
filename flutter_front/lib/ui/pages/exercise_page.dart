import 'dart:async';

import 'package:FlutterApp/constants/app_routes.dart';
import 'package:FlutterApp/constants/app_spacing.dart';
import 'package:FlutterApp/providers/routine_provider.dart';
import 'package:FlutterApp/ui/theme/app_colors.dart';
import 'package:FlutterApp/ui/theme/app_fonts.dart';
import 'package:FlutterApp/ui/widgets/common/accent_bar.dart';
import 'package:FlutterApp/ui/widgets/common/gradient_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ExercisePage extends StatefulWidget {
  const ExercisePage({
    required this.hour,
    super.key,
  });

  final int hour;

  @override
  State<ExercisePage> createState() => _ExercisePageState();
}

class _ExercisePageState extends State<ExercisePage> {
  Timer? _timer;
  late int _currentHour;
  int _remainingSeconds = 0;
  int _totalSeconds = 0;
  bool _running = false;
  bool _hasCompletedSet = false;

  @override
  void initState() {
    super.initState();
    _currentHour = widget.hour;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadHour(context.read<RoutineProvider>(), _currentHour);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _loadHour(RoutineProvider routineProvider, int hour) {
    final routine = routineProvider.routineForHour(hour);
    _currentHour = hour;
    _totalSeconds = routine.exercise.durationSeconds;
    _remainingSeconds = routine.exercise.durationSeconds;
    _running = false;
    _hasCompletedSet = routineProvider.isHourCompleted(hour);
  }

  void _toggleTimer() {
    if (_running) {
      _timer?.cancel();
      setState(() {
        _running = false;
      });
      return;
    }

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (!mounted) {
        return;
      }
      if (_remainingSeconds <= 1) {
        _timer?.cancel();
        setState(() {
          _remainingSeconds = 0;
          _running = false;
          _hasCompletedSet = true;
        });
        await context.read<RoutineProvider>().markHourCompleted(_currentHour);
        if (mounted) {
          await _showCompletionDialog();
        }
        return;
      }

      setState(() {
        _remainingSeconds--;
      });
    });

    setState(() {
      _running = true;
    });
  }

  Future<void> _showCompletionDialog() {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: const Text('🎉 Session Complete'),
        content: const Text(
          "You've completed your hourly exercise! Time for a short water "
          'break.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.go(AppRoutes.home);
            },
            child: const Text('Done'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              setState(() {
                _remainingSeconds = _totalSeconds;
              });
              _toggleTimer();
            },
            child: const Text('Repeat'),
          ),
        ],
      ),
    );
  }

  Future<void> _showExerciseInfoDialog() {
    final routine = context.read<RoutineProvider>().routineForHour(
      _currentHour,
    );
    return showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        title: Text(
          '${routine.exercise.emoji} ${routine.exercise.name}',
          style: AppFonts.display(size: 20, color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Motivation',
              style: AppFonts.body(
                weight: FontWeight.w700,
                color: AppColors.primaryBlue,
              ),
            ),
            Gaps.hXs,
            Text(
              routine.exercise.motivation,
              style: AppFonts.body(color: AppColors.textGray),
            ),
            Gaps.hSm,
            Text(
              'Instruction',
              style: AppFonts.body(
                weight: FontWeight.w700,
                color: AppColors.primaryBlue,
              ),
            ),
            Gaps.hXs,
            Text(
              routine.exercise.instruction,
              style: AppFonts.body(color: AppColors.textGray),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Close',
              style: AppFonts.body(
                weight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _moveHour(int offset) {
    final hours =
        context
            .read<RoutineProvider>()
            .hourlyRoutine
            .map((item) => item.hour)
            .toList()
          ..sort();
    final currentIndex = hours.indexOf(_currentHour);
    final nextIndex = (currentIndex + offset).clamp(0, hours.length - 1);
    if (nextIndex == currentIndex) {
      return;
    }

    _timer?.cancel();
    setState(() {
      _loadHour(context.read<RoutineProvider>(), hours[nextIndex]);
    });
  }

  String _formatDuration(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final routineProvider = context.watch<RoutineProvider>();
    final routine = routineProvider.routineForHour(_currentHour);
    final progress = _totalSeconds == 0
        ? 0.0
        : 1 - (_remainingSeconds / _totalSeconds);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: Insets.screen,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap: () => context.go(AppRoutes.home),
                          child: Text(
                            '◄ Back',
                            style: AppFonts.body(color: Colors.white),
                          ),
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: _showExerciseInfoDialog,
                          tooltip: 'Exercise details',
                          icon: const Text(
                            '💬',
                            style: TextStyle(fontSize: 22),
                          ),
                        ),
                      ],
                    ),
                    Gaps.hXs,
                    Text(
                      'Stay Active at Work',
                      style: AppFonts.display(color: AppColors.primaryBlue),
                    ),
                    Gaps.hXs,
                    Text(
                      'Hourly stretches to refresh your body and boost focus',
                      style: AppFonts.body(
                        size: 13,
                        color: AppColors.textGray2,
                      ),
                    ),
                    Gaps.hSm,
                    AccentBar.blue,
                    Gaps.hLg,
                    GradientCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${routine.exercise.emoji} '
                            '${routine.exercise.name}',
                            style: AppFonts.body(
                              size: 16,
                              weight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                          Gaps.hSm,
                          Text(
                            '🫧 Motivation: ${routine.exercise.motivation}',
                            style: AppFonts.body(
                              size: 13,
                              color: AppColors.textGray,
                            ),
                          ),
                          Gaps.hSm,
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppColors.overlayLight,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              routine.exercise.instruction,
                              style: AppFonts.body(
                                size: 13,
                                color: AppColors.textGray3,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gaps.hXl,
                    Center(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 280,
                            width: 280,
                            child: CircularProgressIndicator(
                              value: progress.clamp(0, 1),
                              strokeWidth: 10,
                              backgroundColor: AppColors.overlayLight,
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                AppColors.purpleStart,
                              ),
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _formatDuration(_remainingSeconds),
                                style: AppFonts.display(
                                  size: 56,
                                  color: Colors.white,
                                ),
                              ),
                              Gaps.hXs,
                              Text(
                                _running
                                    ? 'Keep going'
                                    : _hasCompletedSet
                                    ? 'Done for this hour'
                                    : "Let's go",
                                style: AppFonts.body(
                                  size: 20,
                                  color: AppColors.textGray,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Gaps.hXl,
                    Row(
                      children: [
                        _CircleButton(
                          icon: '⏮',
                          onTap: () => _moveHour(-1),
                        ),
                        Gaps.wSm,
                        Expanded(
                          child: FilledButton(
                            style: FilledButton.styleFrom(
                              backgroundColor: _running
                                  ? AppColors.red
                                  : AppColors.greenStart,
                              minimumSize: const Size.fromHeight(54),
                            ),
                            onPressed: _toggleTimer,
                            child: Text(_running ? 'Pause' : 'Start'),
                          ),
                        ),
                        Gaps.wSm,
                        _CircleButton(
                          icon: '⏭',
                          onTap: () => _moveHour(1),
                        ),
                      ],
                    ),
                    Gaps.hLg,
                    GradientCard(
                      padding: const EdgeInsets.fromLTRB(
                        AppSpacing.md,
                        AppSpacing.sm,
                        AppSpacing.md,
                        AppSpacing.md,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AccentBar.purple,
                          Gaps.hSm,
                          Text(
                            '🕐 Hour:',
                            style: AppFonts.body(color: AppColors.textGray),
                          ),
                          Gaps.hXs,
                          Text(
                            '${routine.label} — ${routine.sublabel}',
                            style: AppFonts.body(
                              weight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                          Gaps.hXs,
                          Text(
                            _hasCompletedSet
                                ? '📈 Streak continues!'
                                : '⏳ Finish this set to log progress.',
                            style: AppFonts.body(
                              size: 13,
                              color: _hasCompletedSet
                                  ? AppColors.greenStart
                                  : AppColors.textGray,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gaps.hLg,
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.onTap,
  });

  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.darkCard,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          height: 54,
          width: 54,
          child: Center(
            child: Text(icon, style: const TextStyle(fontSize: 18)),
          ),
        ),
      ),
    );
  }
}
