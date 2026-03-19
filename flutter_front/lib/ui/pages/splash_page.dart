import 'dart:async';

import 'package:FlutterApp/constants/app_durations.dart';
import 'package:FlutterApp/constants/app_routes.dart';
import 'package:FlutterApp/constants/app_sizes.dart';
import 'package:FlutterApp/constants/app_strings.dart';
import 'package:FlutterApp/providers/app_bootstrap_provider.dart';
import 'package:FlutterApp/providers/settings_provider.dart';
import 'package:FlutterApp/ui/theme/app_colors.dart';
import 'package:FlutterApp/ui/theme/app_fonts.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  static const _segmentCount = 16;

  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppDurations.splash,
    )..addStatusListener(_handleAnimationStatus);
    unawaited(_controller.forward().orCancel);
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed || !mounted) {
      return;
    }
    unawaited(_goNext());
  }

  Future<void> _goNext() async {
    final bootstrap = context.read<AppBootstrapProvider>();
    final settings = context.read<SettingsProvider>();

    if (!settings.loaded) {
      await settings.load();
    }

    if (kDebugMode && mounted) {
      final store = Provider.of<DevicePreviewStore?>(context, listen: false);
      if (store != null) {
        store.data = store.data.copyWith(
          isEnabled: settings.devicePreviewEnabled,
          isToolbarVisible: settings.devicePreviewEnabled,
          isFrameVisible: settings.devicePreviewEnabled,
        );
      }
    }

    if (!bootstrap.isReady) {
      await bootstrap.initialize();
    }
    if (!mounted) {
      return;
    }
    context.go(
      bootstrap.isFirstLaunch ? AppRoutes.welcome : AppRoutes.home,
    );
  }

  @override
  void dispose() {
    _controller
      ..removeStatusListener(_handleAnimationStatus)
      ..dispose();
    super.dispose();
  }

  Color _segmentColor(int index) {
    const activeColors = [
      AppColors.primaryBlue,
      AppColors.cyanEnd,
      AppColors.purpleStart,
      AppColors.greenStart,
    ];
    final progress = _controller.value;
    final waveCenter = progress * (_segmentCount - 1);
    final distance = (index - waveCenter).abs();
    final intensity = (1 - (distance / 4.5)).clamp(0.0, 1.0);
    final colorProgress = (progress * (activeColors.length - 1)).clamp(
      0.0,
      1.0,
    );
    final paletteIndex = colorProgress.floor();
    final nextPaletteIndex = (paletteIndex + 1).clamp(
      0,
      activeColors.length - 1,
    );
    final paletteT = colorProgress - paletteIndex;
    final activeColor = Color.lerp(
      activeColors[paletteIndex],
      activeColors[nextPaletteIndex],
      paletteT,
    )!;

    return Color.lerp(
      AppColors.overlayMedium,
      activeColor,
      Curves.easeOut.transform(intensity),
    )!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  AppStrings.splashLoading,
                  style: AppFonts.display(size: 40, color: Colors.white),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(_segmentCount, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 120),
                      curve: Curves.easeOut,
                      width: AppSizes.loadingSegmentWidth,
                      height: AppSizes.loadingSegmentHeight,
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      decoration: BoxDecoration(
                        color: _segmentColor(index),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  }),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
