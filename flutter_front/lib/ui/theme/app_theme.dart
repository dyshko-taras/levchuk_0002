import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_fonts.dart';

abstract final class AppTheme {
  static ThemeData get dark {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primaryBlue,
      brightness: Brightness.dark,
      surface: AppColors.background,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.background,
      fontFamily: AppFonts.bodyFamily,
      textTheme: TextTheme(
        headlineLarge: AppFonts.display(size: 36, color: Colors.white),
        headlineMedium: AppFonts.display(
          size: 26,
          color: AppColors.primaryBlue,
        ),
        titleLarge: AppFonts.display(size: 20, color: Colors.white),
        bodyLarge: AppFonts.body(size: 16, color: Colors.white),
        bodyMedium: AppFonts.body(size: 14, color: Colors.white),
        bodySmall: AppFonts.body(size: 13, color: AppColors.textGray2),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
    );
  }
}
