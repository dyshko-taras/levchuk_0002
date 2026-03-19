import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../constants/app_durations.dart';
import '../../constants/app_routes.dart';
import '../../constants/app_sizes.dart';
import '../../constants/app_strings.dart';
import '../../providers/app_bootstrap_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(AppDurations.splash, _goNext);
  }

  Future<void> _goNext() async {
    final bootstrap = context.read<AppBootstrapProvider>();
    if (!bootstrap.initialized) {
      await bootstrap.initialize();
    }
    if (!mounted) {
      return;
    }
    context.go(bootstrap.isFirstLaunch ? AppRoutes.welcome : AppRoutes.home);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
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
              children: List.generate(16, (index) {
                return Container(
                  width: AppSizes.loadingSegmentWidth,
                  height: AppSizes.loadingSegmentHeight,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: index < 7
                        ? AppColors.primaryBlue
                        : AppColors.overlayMedium,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
