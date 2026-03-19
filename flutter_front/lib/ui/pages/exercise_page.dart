import 'package:flutter/material.dart';

import '../../constants/app_spacing.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common/accent_bar.dart';
import '../widgets/common/gradient_card.dart';

class ExercisePage extends StatelessWidget {
  const ExercisePage({
    required this.hour,
    super.key,
  });

  final int hour;

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
                'Stay Active at Work',
                style: AppFonts.display(size: 26, color: AppColors.primaryBlue),
              ),
              Gaps.hXs,
              Text(
                'Hourly exercise for hour $hour will be implemented in Phase 5.',
                style: AppFonts.body(size: 13, color: AppColors.textGray2),
              ),
              Gaps.hSm,
              AccentBar.blue,
              Gaps.hLg,
              const GradientCard(
                child: Text(
                  'Timer logic, completion flow, and routine data binding come in Phase 5.',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
