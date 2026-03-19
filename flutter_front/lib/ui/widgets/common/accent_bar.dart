import 'package:FlutterApp/ui/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AccentBar extends StatelessWidget {
  const AccentBar({
    required this.colors,
    super.key,
    this.height = 8,
  });

  final List<Color> colors;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        gradient: LinearGradient(colors: colors),
      ),
    );
  }

  static const blue = AccentBar(
    colors: [Color(0xFF28BAE8), Color(0xFF176ECA)],
  );

  static const purple = AccentBar(
    colors: [AppColors.purpleStart, AppColors.purpleEnd],
  );
}
