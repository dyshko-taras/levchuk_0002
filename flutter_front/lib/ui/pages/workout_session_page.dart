import 'package:FlutterApp/constants/app_routes.dart';
import 'package:FlutterApp/constants/app_spacing.dart';
import 'package:FlutterApp/providers/workout_provider.dart';
import 'package:FlutterApp/ui/theme/app_colors.dart';
import 'package:FlutterApp/ui/theme/app_fonts.dart';
import 'package:FlutterApp/ui/widgets/common/accent_bar.dart';
import 'package:FlutterApp/ui/widgets/common/gradient_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
                  provider
                    ..dismissCompletion()
                    ..stopSession();
                  Navigator.of(dialogContext).pop();
                  context.go(AppRoutes.home);
                },
                child: const Text('Done'),
              ),
              FilledButton(
                onPressed: () {
                  provider
                    ..dismissCompletion()
                    ..restartSession();
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) {
          return;
        }
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No active workout session. Start a routine first.'),
          ),
        );
        context.go(AppRoutes.workout);
      });
      return const Scaffold(
        body: SizedBox.expand(),
      );
    }

    final progress = step.durationSeconds == 0
        ? 0.0
        : 1 - (provider.sessionRemainingSeconds / step.durationSeconds);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: Insets.screen,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
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
                      style: AppFonts.display(color: AppColors.primaryBlue),
                    ),
                    Gaps.hXs,
                    Text(
                      'Move through your custom routine one step at a time',
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
                          Text(
                            _formatDuration(provider.sessionRemainingSeconds),
                            style: AppFonts.display(
                              size: 56,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Gaps.hXl,
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
                            child: Text(
                              provider.sessionRunning ? 'Pause' : 'Start',
                            ),
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
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: provider.stopSession,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size.fromHeight(52),
                          side: const BorderSide(
                            color: AppColors.red,
                            width: 2,
                          ),
                        ),
                        icon: const Icon(
                          Icons.stop_circle_outlined,
                          color: AppColors.red,
                        ),
                        label: Text(
                          'Stop Routine',
                          style: AppFonts.body(
                            weight: FontWeight.w600,
                            color: AppColors.textGray,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
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
