import 'package:FlutterApp/constants/app_routes.dart';
import 'package:FlutterApp/constants/app_spacing.dart';
import 'package:FlutterApp/ui/theme/app_colors.dart';
import 'package:FlutterApp/ui/theme/app_fonts.dart';
import 'package:FlutterApp/ui/widgets/common/accent_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    required this.title,
    super.key,
    this.subtitle,
    this.showBack = false,
    this.showGear = false,
    this.accentColor = ScreenHeaderAccent.blue,
    this.rightIcon,
    this.onRightIconTap,
  });

  final String title;
  final String? subtitle;
  final bool showBack;
  final bool showGear;
  final ScreenHeaderAccent accentColor;
  final String? rightIcon;
  final VoidCallback? onRightIconTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Insets.screen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showBack)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.xxs),
              child: InkWell(
                onTap: () => context.pop(),
                child: Text(
                  '◄ Back',
                  style: AppFonts.body(color: Colors.white),
                ),
              ),
            ),
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: AppFonts.display(
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
              if (rightIcon != null)
                IconButton(
                  onPressed: onRightIconTap,
                  icon: Text(rightIcon!, style: const TextStyle(fontSize: 22)),
                ),
              if (showGear)
                IconButton(
                  onPressed: () => context.go(AppRoutes.settings),
                  icon: const Text('⚙️', style: TextStyle(fontSize: 22)),
                ),
            ],
          ),
          if (subtitle != null)
            Text(
              subtitle!,
              style: AppFonts.body(
                size: 13,
                color: AppColors.textGray2,
              ),
            ),
          Gaps.hSm,
          if (accentColor == ScreenHeaderAccent.purple)
            AccentBar.purple
          else
            AccentBar.blue,
        ],
      ),
    );
  }
}

enum ScreenHeaderAccent {
  blue,
  purple,
}
