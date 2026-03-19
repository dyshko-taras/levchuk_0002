import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/app_images.dart';
import '../../../constants/app_routes.dart';
import '../../../constants/app_spacing.dart';
import '../../../constants/app_strings.dart';
import '../../theme/app_colors.dart';
import '../../theme/app_fonts.dart';
import '../../widgets/common/accent_bar.dart';
import '../../widgets/common/gradient_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: Insets.screen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  AppImages.homeHero,
                  height: 120,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Gaps.hMd,
              Row(
                children: [
                  Expanded(
                    child: Text(
                      AppStrings.homeTitle,
                      style: AppFonts.display(
                        size: 26,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => context.go(AppRoutes.settings),
                    icon: const Text('⚙️', style: TextStyle(fontSize: 22)),
                  ),
                ],
              ),
              Text(
                AppStrings.homeSubtitle,
                style: AppFonts.body(size: 13, color: AppColors.textGray2),
              ),
              Gaps.hSm,
              AccentBar.blue,
              Gaps.hLg,
              const _ProgressCard(),
              Gaps.hXl,
              Text(
                '🕐 ${AppStrings.hourlyRoutineTitle}',
                style: AppFonts.display(size: 18, color: Colors.white),
              ),
              Gaps.hSm,
              ...List.generate(8, (index) {
                final hour = index + 1;
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: InkWell(
                    onTap: () => context.push(AppRoutes.exerciseForHour(hour)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.overlayLight,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${hour}th Hour',
                              style: AppFonts.body(color: Colors.white),
                            ),
                          ),
                          Text(
                            'Foundation Preview  ►',
                            style: AppFonts.body(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
              Gaps.hLg,
              Text(
                '✨ ${AppStrings.quickActionsTitle}',
                style: AppFonts.display(size: 18, color: Colors.white),
              ),
              Gaps.hSm,
              Row(
                children: [
                  Expanded(
                    child: _ActionCard(
                      emoji: '🏃',
                      label: 'Quick Stretch',
                      onTap: () => context.push(AppRoutes.exerciseForHour(1)),
                    ),
                  ),
                  Gaps.wSm,
                  Expanded(
                    child: _ActionCard(
                      emoji: '🌬️',
                      label: 'Open Breathe',
                      onTap: () => context.go(AppRoutes.breathe),
                    ),
                  ),
                  Gaps.wSm,
                  Expanded(
                    child: _ActionCard(
                      emoji: '💡',
                      label: 'Tips of the Day',
                      onTap: () => context.go(AppRoutes.tips),
                    ),
                  ),
                ],
              ),
              Gaps.hLg,
              GradientCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AccentBar.purple,
                    Gaps.hSm,
                    Text(
                      '✨ ${AppStrings.quoteOfDayTitle}:',
                      style: AppFonts.body(
                        weight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    Gaps.hXs,
                    Text(
                      '"Small steps every day add up to big results."',
                      style: AppFonts.body(color: Colors.white),
                    ),
                    Gaps.hXs,
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        '— Foundation Preview',
                        style: AppFonts.body(size: 13, color: AppColors.purpleStart),
                      ),
                    ),
                  ],
                ),
              ),
              Gaps.hLg,
            ],
          ),
        ),
      ),
    );
  }
}

class _ProgressCard extends StatelessWidget {
  const _ProgressCard();

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '📅 ${AppStrings.progressTitle}',
            style: AppFonts.body(
              size: 16,
              weight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          Gaps.hSm,
          const _ProgressRow(label: '✅ Completed Hours:', value: '0 / 8'),
          Gaps.hXs,
          const _ProgressRow(label: '🏃 Breathing:', value: '0 min'),
          Gaps.hXs,
          const _ProgressRow(label: '🔥 Streak:', value: '0 days'),
          Gaps.hSm,
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '🔄 Reset Day',
              style: AppFonts.body(size: 13, color: AppColors.primaryBlue),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressRow extends StatelessWidget {
  const _ProgressRow({
    required this.label,
    required this.value,
  });

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: AppColors.overlayLight,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppFonts.body(color: Colors.white))),
          Text(
            value,
            style: AppFonts.body(
              weight: FontWeight.w700,
              color: AppColors.greenStart,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.emoji,
    required this.label,
    required this.onTap,
  });

  final String emoji;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        height: 104,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.purpleStart, AppColors.purpleEnd],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.md,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 28)),
              Gaps.hXs,
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppFonts.body(
                  weight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
