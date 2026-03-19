import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/app_images.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_spacing.dart';
import '../../providers/breathing_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common/screen_header.dart';

class BreathingPage extends StatefulWidget {
  const BreathingPage({super.key});

  @override
  State<BreathingPage> createState() => _BreathingPageState();
}

class _BreathingPageState extends State<BreathingPage> {
  bool _completionDialogVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      final provider = context.read<BreathingProvider>();
      if (!provider.sessionRunning && !provider.sessionCompleted) {
        provider.startSession();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<BreathingProvider>();

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
            title: const Text('🎉 Well done!'),
            content: const Text("You've completed your breathing session"),
            actions: [
              TextButton(
                onPressed: () {
                  provider.dismissCompletion();
                  provider.stopSession();
                  Navigator.of(dialogContext).pop();
                  context.go(AppRoutes.home);
                },
                child: const Text('Back to Home'),
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

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage(AppImages.breathingBackground),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    AppColors.background.withValues(alpha: 0.78),
                    BlendMode.darken,
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: Insets.screen,
                  child: ScreenHeader(
                    title: 'Focus Breathing',
                    subtitle: 'Relax your mind. Refocus your energy',
                    rightIcon: '⚙️',
                    onRightIconTap: () =>
                        context.push(AppRoutes.breathingSettings),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: Insets.screen,
                    child: Column(
                      children: [
                        Text(
                          _formatDuration(provider.remainingSeconds),
                          style: AppFonts.display(
                            size: 56,
                            color: Colors.white,
                          ),
                        ),
                        Gaps.hXs,
                        Text(
                          'Cycle ${provider.currentCycle} of ${provider.totalCycles}',
                          style: AppFonts.body(
                            size: 14,
                            color: AppColors.textGray,
                          ),
                        ),
                        Gaps.hXl,
                        Expanded(
                          child: Center(
                            child: SizedBox(
                              height: 320,
                              width: 320,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  _Ring(size: 320, opacity: 0.06),
                                  _Ring(size: 270, opacity: 0.10),
                                  _Ring(size: 220, opacity: 0.15),
                                  _Ring(size: 170, opacity: 0.20),
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeInOut,
                                    height: 320 * provider.circleScale,
                                    width: 320 * provider.circleScale,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                        colors: [
                                          AppColors.cyanStart,
                                          AppColors.cyanEnd,
                                        ],
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      provider.phaseLabel,
                                      style: AppFonts.body(
                                        size: 18,
                                        weight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            _CircleControl(
                              icon: '⚙️',
                              onTap: () =>
                                  context.push(AppRoutes.breathingSettings),
                            ),
                            Gaps.wSm,
                            Expanded(
                              child: FilledButton(
                                style: FilledButton.styleFrom(
                                  backgroundColor: AppColors.red,
                                  minimumSize: const Size.fromHeight(54),
                                ),
                                onPressed: provider.sessionRunning
                                    ? provider.pauseSession
                                    : provider.startSession,
                                child: Text(
                                  provider.sessionRunning ? 'Pause' : 'Start',
                                ),
                              ),
                            ),
                            Gaps.wSm,
                            _CircleControl(
                              icon: '🔄',
                              onTap: provider.restartSession,
                            ),
                          ],
                        ),
                        Gaps.hSm,
                        TextButton(
                          onPressed: provider.stopSession,
                          child: Text(
                            'Stop session',
                            style: AppFonts.body(color: AppColors.textGray),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDuration(int totalSeconds) {
    final minutes = (totalSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (totalSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _Ring extends StatelessWidget {
  const _Ring({
    required this.size,
    required this.opacity,
  });

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: size,
      width: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.cyanEnd.withValues(alpha: opacity),
      ),
    );
  }
}

class _CircleControl extends StatelessWidget {
  const _CircleControl({
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
