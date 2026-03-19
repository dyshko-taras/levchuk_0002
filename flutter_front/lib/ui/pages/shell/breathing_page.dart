import 'package:FlutterApp/constants/app_images.dart';
import 'package:FlutterApp/constants/app_routes.dart';
import 'package:FlutterApp/constants/app_spacing.dart';
import 'package:FlutterApp/providers/breathing_provider.dart';
import 'package:FlutterApp/ui/theme/app_colors.dart';
import 'package:FlutterApp/ui/theme/app_fonts.dart';
import 'package:FlutterApp/ui/widgets/common/screen_header.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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
                  provider
                    ..dismissCompletion()
                    ..stopSession();
                  Navigator.of(dialogContext).pop();
                  context.go(AppRoutes.home);
                },
                child: const Text('Back to Home'),
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          ScreenHeader(
                            title: 'Focus Breathing',
                            subtitle: 'Relax your mind. Refocus your energy',
                            rightIcon: '⚙️',
                            onRightIconTap: () =>
                                context.push(AppRoutes.breathingSettings),
                          ),
                          Gaps.hLg,
                          Padding(
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
                                  'Cycle ${provider.currentCycle} of '
                                  '${provider.totalCycles}',
                                  style: AppFonts.body(
                                    color: AppColors.textGray,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: Insets.screen,
                            child: _BreathingAnimation(
                              phaseLabel: provider.phaseLabel,
                              circleScale: provider.circleScale,
                            ),
                          ),
                          const Spacer(),
                          Padding(
                            padding: Insets.screen,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    _CircleControl(
                                      icon: '⚙️',
                                      onTap: () => context.push(
                                        AppRoutes.breathingSettings,
                                      ),
                                    ),
                                    Gaps.wSm,
                                    Expanded(
                                      child: FilledButton(
                                        style: FilledButton.styleFrom(
                                          backgroundColor: AppColors.red,
                                          minimumSize: const Size.fromHeight(
                                            54,
                                          ),
                                        ),
                                        onPressed: provider.sessionRunning
                                            ? provider.pauseSession
                                            : provider.startSession,
                                        child: Text(
                                          provider.sessionRunning
                                              ? 'Pause'
                                              : 'Start',
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
                                      'Stop Session',
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
                        ],
                      ),
                    ),
                  ),
                );
              },
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

class _BreathingAnimation extends StatelessWidget {
  const _BreathingAnimation({
    required this.phaseLabel,
    required this.circleScale,
  });

  final String phaseLabel;
  final double circleScale;

  static const _canvasSize = 320.0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _canvasSize,
      width: _canvasSize,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const Center(child: _Ring(size: 320, opacity: 0.06)),
          const Center(child: _Ring(size: 270, opacity: 0.10)),
          const Center(child: _Ring(size: 220, opacity: 0.15)),
          const Center(child: _Ring(size: 170, opacity: 0.20)),
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              height: _canvasSize * circleScale,
              width: _canvasSize * circleScale,
              alignment: Alignment.center,
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
              child: Text(
                phaseLabel,
                textAlign: TextAlign.center,
                style: AppFonts.body(
                  size: 18,
                  weight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
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
