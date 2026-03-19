import 'package:FlutterApp/constants/app_icons.dart';
import 'package:FlutterApp/constants/app_spacing.dart';
import 'package:FlutterApp/ui/theme/app_fonts.dart';
import 'package:flutter/material.dart';

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const List<(String, String)> _items = [
    (AppIcons.home, 'Home'),
    (AppIcons.tips, 'Tips'),
    (AppIcons.breathe, 'Breathe'),
    (AppIcons.quotes, 'Quotes'),
    (AppIcons.workout, 'Workout'),
    (AppIcons.settings, 'Settings'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF1D263B),
      padding: const EdgeInsets.only(top: AppSpacing.xs, bottom: AppSpacing.sm),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_items.length, (index) {
            final item = _items[index];
            final active = index == currentIndex;
            return Expanded(
              child: InkWell(
                onTap: () => onTap(index),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.xxs),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 6,
                        width: 36,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(6),
                          ),
                          gradient: active
                              ? const LinearGradient(
                                  colors: [
                                    Color(0xFF53ADFF),
                                    Color(0xFF135AC2),
                                  ],
                                )
                              : null,
                        ),
                      ),
                      Gaps.hXs,
                      Text(item.$1, style: const TextStyle(fontSize: 18)),
                      Text(
                        item.$2,
                        style: AppFonts.body(
                          size: 11,
                          weight: active ? FontWeight.w600 : FontWeight.w400,
                          color: Colors.white,
                        ).copyWith(fontFamily: AppFonts.displayFamily),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
