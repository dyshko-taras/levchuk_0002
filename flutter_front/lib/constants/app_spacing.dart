import 'package:flutter/widgets.dart';

abstract final class AppSpacing {
  static const xxs = 4.0;
  static const xs = 8.0;
  static const sm = 12.0;
  static const md = 16.0;
  static const lg = 20.0;
  static const xl = 24.0;
  static const xxl = 32.0;
  static const screenPadding = 20.0;
}

abstract final class Gaps {
  static const hXs = SizedBox(height: AppSpacing.xs);
  static const hSm = SizedBox(height: AppSpacing.sm);
  static const hMd = SizedBox(height: AppSpacing.md);
  static const hLg = SizedBox(height: AppSpacing.lg);
  static const hXl = SizedBox(height: AppSpacing.xl);
  static const wXs = SizedBox(width: AppSpacing.xs);
  static const wSm = SizedBox(width: AppSpacing.sm);
  static const wMd = SizedBox(width: AppSpacing.md);
}

abstract final class Insets {
  static const allMd = EdgeInsets.all(AppSpacing.md);
  static const allLg = EdgeInsets.all(AppSpacing.lg);
  static const screen = EdgeInsets.symmetric(
    horizontal: AppSpacing.screenPadding,
  );
}
