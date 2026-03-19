import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_spacing.dart';
import '../../enums/enums.dart';
import '../../providers/breathing_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common/screen_header.dart';

class BreathingSettingsPage extends StatelessWidget {
  const BreathingSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final breathingProvider = context.watch<BreathingProvider>();
    final settings = breathingProvider.settings;
    const durations = [1, 3, 5, 10];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ScreenHeader(
              title: 'Settings Panel',
              showBack: true,
            ),
            Expanded(
              child: ListView(
                padding: Insets.screen,
                children: [
                  Text(
                    'Duration, (min):',
                    style: AppFonts.body(color: AppColors.textGray),
                  ),
                  Gaps.hSm,
                  Row(
                    children: durations
                        .map(
                          (duration) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: AppSpacing.xs,
                              ),
                              child: _SelectChip(
                                label: '$duration',
                                selected: settings.durationMinutes == duration,
                                onTap: () =>
                                    breathingProvider.updateDuration(duration),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  Gaps.hLg,
                  Text(
                    'Mode:',
                    style: AppFonts.body(color: AppColors.textGray),
                  ),
                  Gaps.hSm,
                  Row(
                    children: BreathingMode.values
                        .map(
                          (mode) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: AppSpacing.xs,
                              ),
                              child: _SelectChip(
                                label: _modeLabel(mode),
                                selected: settings.mode == mode,
                                onTap: () => breathingProvider.updateMode(mode),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  Gaps.hLg,
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.darkCard,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Sound:',
                            style: AppFonts.body(color: Colors.white),
                          ),
                        ),
                        Switch(
                          value: settings.soundEnabled,
                          activeColor: AppColors.greenStart,
                          onChanged: breathingProvider.updateSound,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _modeLabel(BreathingMode mode) {
    switch (mode) {
      case BreathingMode.calm:
        return 'Calm';
      case BreathingMode.energy:
        return 'Energy';
      case BreathingMode.focus:
        return 'Focus';
    }
  }
}

class _SelectChip extends StatelessWidget {
  const _SelectChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: selected ? AppColors.greenStart : AppColors.darkCard,
        minimumSize: const Size.fromHeight(52),
      ),
      onPressed: onTap,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: AppFonts.body(
          weight: selected ? FontWeight.w700 : FontWeight.w400,
          color: selected ? Colors.white : AppColors.textGray,
        ),
      ),
    );
  }
}
