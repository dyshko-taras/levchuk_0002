import 'package:FlutterApp/constants/app_images.dart';
import 'package:FlutterApp/constants/app_routes.dart';
import 'package:FlutterApp/constants/app_spacing.dart';
import 'package:FlutterApp/constants/app_strings.dart';
import 'package:FlutterApp/providers/quotes_provider.dart';
import 'package:FlutterApp/providers/routine_provider.dart';
import 'package:FlutterApp/providers/tips_provider.dart';
import 'package:FlutterApp/ui/theme/app_colors.dart';
import 'package:FlutterApp/ui/theme/app_fonts.dart';
import 'package:FlutterApp/ui/widgets/common/accent_bar.dart';
import 'package:FlutterApp/ui/widgets/common/gradient_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final routineProvider = context.watch<RoutineProvider>();
    final quotesProvider = context.watch<QuotesProvider>();
    final tipsProvider = context.watch<TipsProvider>();
    final quote = quotesProvider.quoteOfTheDay;
    final tip = tipsProvider.tipOfTheDay();
    final featuredTopicId = tipsProvider.topics.isEmpty
        ? null
        : tipsProvider.topics.first.id;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: Insets.screen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.hSm,
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
              _ProgressCard(
                completedHours: routineProvider.completedHoursCount,
                breathingMinutes: routineProvider.breathingMinutes,
                streakDays: routineProvider.streakDays,
                onResetTap: routineProvider.resetToday,
              ),
              Gaps.hXl,
              Text(
                '🕐 ${AppStrings.hourlyRoutineTitle}',
                style: AppFonts.display(size: 18, color: Colors.white),
              ),
              Gaps.hSm,
              ...routineProvider.hourlyRoutine.map((item) {
                final hour = item.hour;
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                  child: InkWell(
                    onTap: () => context.push(
                      AppRoutes.exerciseForHour(hour),
                    ),
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
                              item.label,
                              style: AppFonts.body(color: Colors.white),
                            ),
                          ),
                          Text(
                            '${item.exercise.name} '
                            '${routineProvider.statusEmojiForHour(hour)}  ►',
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
              SizedBox(
                height: 120,
                child: Row(
                  children: [
                    Expanded(
                      child: _ActionCard(
                        emoji: '🏃',
                        label: 'Quick Stretch',
                        onTap: () => context.push(
                          AppRoutes.exerciseForHour(1),
                        ),
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
                        onTap: () => context.go(
                          tip == null || featuredTopicId == null
                              ? AppRoutes.tips
                              : AppRoutes.tipDetail(featuredTopicId),
                        ),
                      ),
                    ),
                  ],
                ),
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
                      quote == null
                          ? '"No quote available yet."'
                          : '"${quote.text}"',
                      style: AppFonts.body(color: Colors.white),
                    ),
                    Gaps.hXs,
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        quote == null ? '—' : '— ${quote.author}',
                        style: AppFonts.body(
                          size: 13,
                          color: AppColors.purpleStart,
                        ),
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
  const _ProgressCard({
    required this.completedHours,
    required this.breathingMinutes,
    required this.streakDays,
    required this.onResetTap,
  });

  final int completedHours;
  final int breathingMinutes;
  final int streakDays;
  final VoidCallback onResetTap;

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
          _ProgressRow(
            label: '✅ Completed Hours:',
            value: '$completedHours / 8',
          ),
          Gaps.hXs,
          _ProgressRow(
            label: '🏃 Breathing:',
            value: '$breathingMinutes min',
          ),
          Gaps.hXs,
          _ProgressRow(
            label: '🔥 Streak:',
            value: '$streakDays days',
          ),
          Gaps.hSm,
          InkWell(
            onTap: onResetTap,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                '🔄 Reset Day',
                style: AppFonts.body(
                  size: 13,
                  color: AppColors.primaryBlue,
                ),
              ),
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
          Expanded(
            child: Text(label, style: AppFonts.body(color: Colors.white)),
          ),
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                emoji,
                style: const TextStyle(fontSize: 28),
                textAlign: TextAlign.center,
              ),
              Gaps.hXs,
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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
