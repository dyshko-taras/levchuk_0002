import 'package:FlutterApp/constants/app_images.dart';
import 'package:FlutterApp/constants/app_routes.dart';
import 'package:FlutterApp/constants/app_spacing.dart';
import 'package:FlutterApp/constants/app_strings.dart';
import 'package:FlutterApp/providers/app_bootstrap_provider.dart';
import 'package:FlutterApp/ui/theme/app_colors.dart';
import 'package:FlutterApp/ui/theme/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppImages.welcomeHero, fit: BoxFit.cover),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withAlpha(115),
                  Colors.black.withAlpha(51),
                  Colors.black.withAlpha(179),
                  AppColors.background,
                ],
                stops: const [0, 0.35, 0.72, 1],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.welcomeHeadlineLead,
                    style: AppFonts.display(
                      size: 36,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  Text(
                    AppStrings.welcomeHeadlineBody,
                    style: AppFonts.display(size: 36, color: Colors.white),
                  ),
                  Gaps.hMd,
                  Text(
                    AppStrings.welcomeSubtitle,
                    style: AppFonts.body(size: 15, color: AppColors.textGray),
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: () async {
                      await context
                          .read<AppBootstrapProvider>()
                          .completeOnboarding();
                      if (context.mounted) {
                        context.go(AppRoutes.home);
                      }
                    },
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(56),
                      backgroundColor: AppColors.greenStart,
                      foregroundColor: Colors.white,
                      textStyle: AppFonts.body(
                        size: 16,
                        weight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    child: const Text(AppStrings.getStarted),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
