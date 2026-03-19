import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/app_routes.dart';
import '../../constants/app_spacing.dart';
import '../../providers/workout_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common/accent_bar.dart';
import '../widgets/common/gradient_card.dart';

class WorkoutSessionPage extends StatefulWidget {
  const WorkoutSessionPage({super.key});

  @override
  State<WorkoutSessionPage> createState() => _WorkoutSessionPageState();
}

class _WorkoutSessionPageState extends State<WorkoutSessionPage> {
  bool _completionDialogVisible = false;

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkoutProvider>();
    final step = provider.currentSessionStep;

    if (provider.sessionCompleted && !_completionDialogVisible) {
      _completionDialogVisible = true;
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!mounted) {
          return;
        }
        await showDialog<void>(
          context: context,
          barrierDismissible: false,
          builder: (dialogContext) => AlertDialog(
            title: const Text('🎉 Workout Complete'),
            content: const Text('Your custom workout is logged for today.'),
            actions: [
              TextButton(
                onPressed: () {
                  provider.dismissCompletion();
                  provider.stopSession();
                  Navigator.of(dialogContext).pop();
                  context.go(AppRoutes.home);
                },
                child: const Text('Done'),
              ),
              FilledButton(
                onPressed: () {
                  provider.dismissCompletion();
                  provider.restartSession();
                  Navigator.of(dialogContext).pop();
                },
                child: const Text('Repeat'),
              ),
            ],
          ),
        );
        _completionDialogVisible = false;
      });
    }

    if (step == null) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: Insets.screen,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () => context.pop(),
                  child: Text(
                    '◄ Back',
                    style: AppFonts.body(color: Colors.white),
                  ),
                ),
                Gaps.hMd,
                Text(
                  'Workout Session',
                  style: AppFonts.display(
                    size: 26,
                    color: AppColors.primaryBlue,
                  ),
                ),
                Gaps.hSm,
                Text(
                  'There is no active workout session.',
                  style: AppFonts.body(color: AppColors.textGray),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final progress = step.durationSeconds == 0
        ? 0.0
        : 1 - (provider.sessionRemainingSeconds / step.durationSeconds);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: Insets.screen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  InkWell(
                    onTap: () => context.pop(),
                    child: Text(
                      '◄ Back',
                      style: AppFonts.body(color: Colors.white),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    '${provider.sessionIndex + 1}/${provider.sessionStepCount}',
                    style: AppFonts.body(color: AppColors.textGray),
                  ),
                ],
              ),
              Gaps.hXs,
              Text(
                'Workout Session',
                style: AppFonts.display(size: 26, color: AppColors.primaryBlue),
              ),
              Gaps.hXs,
              Text(
                'Move through your custom routine one step at a time',
                style: AppFonts.body(size: 13, color: AppColors.textGray2),
              ),
              Gaps.hSm,
              AccentBar.blue,
              Gaps.hLg,
              GradientCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.name,
                      style: AppFonts.body(
                        size: 16,
                        weight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Gaps.hSm,
                    Text(
                      step.isCustom ? 'Custom step' : 'Exercise step',
                      style: AppFonts.body(
                        size: 13,
                        color: AppColors.textGray,
                      ),
                    ),
                  ],
                ),
              ),
              Gaps.hXl,
              Expanded(
                child: Center(
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
                      Text(
                        _formatDuration(provider.sessionRemainingSeconds),
                        style: AppFonts.display(size: 56, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  _SessionButton(
                    icon: '⏮',
                    onTap: provider.previousSessionStep,
                  ),
                  Gaps.wSm,
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: provider.sessionRunning
                            ? AppColors.red
                            : AppColors.greenStart,
                        minimumSize: const Size.fromHeight(54),
                      ),
                      onPressed: provider.sessionRunning
                          ? provider.pauseSession
                          : provider.resumeSession,
                      child: Text(provider.sessionRunning ? 'Pause' : 'Start'),
                    ),
                  ),
                  Gaps.wSm,
                  _SessionButton(
                    icon: '⏭',
                    onTap: provider.nextSessionStep,
                  ),
                ],
              ),
              Gaps.hSm,
              TextButton(
                onPressed: provider.stopSession,
                child: Text(
                  'Stop routine',
                  style: AppFonts.body(color: AppColors.textGray),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _SessionButton extends StatelessWidget {
  const _SessionButton({
    required this.icon,
    required this.onTap,
  });

  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Ink(
        height: 54,
        width: 54,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.darkCard,
        ),
        child: Center(
          child: Text(icon, style: const TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}
