import 'package:flutter/material.dart';

import '../../constants/app_spacing.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common/accent_bar.dart';
import '../widgets/common/gradient_card.dart';

class BreathingSettingsPage extends StatelessWidget {
  const BreathingSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: Insets.screen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.hSm,
              Text(
                'Settings Panel',
                style: AppFonts.display(size: 26, color: AppColors.primaryBlue),
              ),
              Gaps.hSm,
              AccentBar.blue,
              Gaps.hLg,
              const GradientCard(
                child: Text(
                  'Breathing duration, mode, and sound controls will be implemented in Phase 5.',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
