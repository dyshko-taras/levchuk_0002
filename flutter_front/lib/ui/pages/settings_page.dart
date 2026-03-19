import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_spacing.dart';
import '../../constants/app_strings.dart';
import '../../providers/routine_provider.dart';
import '../../providers/workout_provider.dart';
import '../../providers/settings_provider.dart';
import '../theme/app_colors.dart';
import '../theme/app_fonts.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: Insets.screen,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Gaps.hSm,
              Text(
                AppStrings.settingsTitle,
                style: AppFonts.display(size: 26, color: AppColors.primaryBlue),
              ),
              Gaps.hLg,
              _ToggleRow(
                label: AppStrings.hourlyRemindersLabel,
                value: settings.hourlyReminders,
                onChanged: settings.setHourlyReminders,
              ),
              Gaps.hXs,
              _ToggleRow(
                label: AppStrings.breathingRemindersLabel,
                value: settings.breathingReminders,
                onChanged: settings.setBreathingReminders,
              ),
              Gaps.hXs,
              _ToggleRow(
                label: AppStrings.soundLabel,
                value: settings.soundEnabled,
                onChanged: settings.setSoundEnabled,
              ),
              if (kDebugMode) ...[
                Gaps.hXs,
                _ToggleRow(
                  label: AppStrings.devicePreviewLabel,
                  value: settings.devicePreviewEnabled,
                  onChanged: (value) async {
                    final store = context.read<DevicePreviewStore>();
                    store.data = store.data.copyWith(
                      isEnabled: value,
                      isToolbarVisible: value,
                      isFrameVisible: value,
                    );
                    await settings.setDevicePreviewEnabled(value);
                  },
                ),
              ],
              Gaps.hXl,
              Text(
                'About',
                style: AppFonts.body(
                  size: 16,
                  weight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              Gaps.hSm,
              Text(
                'Version: 1.0.0',
                style: AppFonts.body(color: AppColors.textGray),
              ),
              Gaps.hXs,
              Text(
                'Build: 2026.03.19',
                style: AppFonts.body(color: AppColors.textGray),
              ),
              Gaps.hXs,
              Text(
                'Brand Integration: ActiveOffice',
                style: AppFonts.body(color: AppColors.textGray),
              ),
              Gaps.hXl,
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  side: const BorderSide(
                    color: AppColors.greenStart,
                    width: 3,
                  ),
                ),
                child: Text(
                  'Share App',
                  style: AppFonts.body(
                    weight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              Gaps.hXs,
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  side: const BorderSide(
                    color: AppColors.greenStart,
                    width: 3,
                  ),
                ),
                child: Text(
                  'Privacy Policy',
                  style: AppFonts.body(
                    weight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              Gaps.hXs,
              FilledButton(
                onPressed: () => _confirmResetProgress(context),
                style: FilledButton.styleFrom(
                  minimumSize: const Size.fromHeight(52),
                  backgroundColor: AppColors.red,
                ),
                child: Text(
                  'Reset Progress',
                  style: AppFonts.body(
                    weight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ),
              Gaps.hLg,
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmResetProgress(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: AppColors.darkCard,
          title: Text(
            'Reset Progress',
            style: AppFonts.display(size: 20, color: Colors.white),
          ),
          content: Text(
            'This clears daily progress and custom workouts.',
            style: AppFonts.body(color: AppColors.textGray),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: AppFonts.body(color: AppColors.textGray3),
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: FilledButton.styleFrom(backgroundColor: AppColors.red),
              child: Text(
                'Reset',
                style: AppFonts.body(
                  weight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    await context.read<RoutineProvider>().clearAllProgress();
    await context.read<WorkoutProvider>().clearAll();
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.darkCard,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Expanded(child: Text(label, style: AppFonts.body(color: Colors.white))),
          Switch.adaptive(
            value: value,
            activeTrackColor: Colors.white,
            activeColor: AppColors.greenStart,
            inactiveTrackColor: Colors.white,
            inactiveThumbColor: Colors.grey,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
