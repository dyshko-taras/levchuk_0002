import 'package:flutter/material.dart';

import '../../constants/app_spacing.dart';
import '../../constants/app_strings.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';
import '../widgets/common/accent_bar.dart';
import '../widgets/common/gradient_card.dart';

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({
    required this.title,
    required this.subtitle,
    super.key,
  });

  final String title;
  final String subtitle;

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
                title,
                style: AppFonts.display(size: 26, color: AppColors.primaryBlue),
              ),
              Gaps.hXs,
              Text(
                subtitle,
                style: AppFonts.body(size: 13, color: AppColors.textGray2),
              ),
              Gaps.hSm,
              AccentBar.blue,
              Gaps.hLg,
              GradientCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.placeholderComingSoon,
                      style: AppFonts.body(
                        weight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    Gaps.hXs,
                    Text(
                      AppStrings.placeholderNextStep,
                      style: AppFonts.body(color: AppColors.textGray),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
