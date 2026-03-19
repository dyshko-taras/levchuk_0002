import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/app_spacing.dart';
import '../../constants/app_strings.dart';
import '../../providers/routine_provider.dart';
import '../../providers/settings_provider.dart';
import '../../providers/workout_provider.dart';
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
              _ReminderToggleRow(
                label: AppStrings.hourlyRemindersLabel,
                value: settings.hourlyReminders,
                warningVisible: settings.showHourlyWarning,
                onChanged: (value) => _handleReminderToggle(
                  context,
                  type: ReminderToggleType.hourly,
                  value: value,
                ),
              ),
              Gaps.hXs,
              _ReminderToggleRow(
                label: AppStrings.breathingRemindersLabel,
                value: settings.breathingReminders,
                warningVisible: settings.showBreathingWarning,
                onChanged: (value) => _handleReminderToggle(
                  context,
                  type: ReminderToggleType.breathing,
                  value: value,
                ),
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

  Future<void> _handleReminderToggle(
    BuildContext context, {
    required ReminderToggleType type,
    required bool value,
  }) async {
    final settings = context.read<SettingsProvider>();

    if (!value) {
      if (type == ReminderToggleType.hourly) {
        await settings.setHourlyReminders(false);
      } else {
        await settings.setBreathingReminders(false);
      }
      return;
    }

    final allow = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.darkCard,
        title: Text(
          'Allow notifications?',
          style: AppFonts.display(size: 20, color: Colors.white),
        ),
        content: Text(
          'ActiveOffice needs notification permission to send you stretch and breathing reminders during your workday.',
          style: AppFonts.body(color: AppColors.textGray),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text(
              'Not now',
              style: AppFonts.body(color: AppColors.textGray3),
            ),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              'Allow',
              style: AppFonts.body(
                weight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );

    if (allow != true || !context.mounted) {
      return;
    }

    final result = await settings.enableReminderAfterPermissionFlow(type);

    if (!context.mounted) {
      return;
    }

    if (result == ReminderPermissionFlowResult.openSettings) {
      final openSettings = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          backgroundColor: AppColors.darkCard,
          title: Text(
            'Notifications blocked',
            style: AppFonts.display(size: 20, color: Colors.white),
          ),
          content: Text(
            'Notifications are disabled. Enable them in system settings to receive reminders.',
            style: AppFonts.body(color: AppColors.textGray),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                'Later',
                style: AppFonts.body(color: AppColors.textGray3),
              ),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: Text(
                'Open Settings',
                style: AppFonts.body(
                  weight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      );

      if (openSettings == true) {
        await settings.openNotificationSettings();
      }
    }
  }

  Future<void> _confirmResetProgress(BuildContext context) async {
    final controller = TextEditingController();
    var errorText = '';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: AppColors.darkCard,
              title: Text(
                'Reset Progress',
                style: AppFonts.display(size: 20, color: Colors.white),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Type RESET to clear daily progress and custom workouts.',
                    style: AppFonts.body(color: AppColors.textGray),
                  ),
                  Gaps.hSm,
                  TextField(
                    controller: controller,
                    style: AppFonts.body(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'RESET',
                      errorText: errorText.isEmpty ? null : errorText,
                    ),
                  ),
                ],
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
                  onPressed: () {
                    if (controller.text.trim() != 'RESET') {
                      setState(() {
                        errorText = 'Type RESET exactly.';
                      });
                      return;
                    }
                    Navigator.of(context).pop(true);
                  },
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
      },
    );

    if (confirmed != true || !context.mounted) {
      return;
    }

    await context.read<RoutineProvider>().clearAllProgress();
    await context.read<WorkoutProvider>().clearAll();
  }
}

class _ReminderToggleRow extends StatelessWidget {
  const _ReminderToggleRow({
    required this.label,
    required this.value,
    required this.warningVisible,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final bool warningVisible;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _ToggleRow(
          label: label,
          value: value,
          onChanged: onChanged,
        ),
        if (warningVisible)
          Padding(
            padding: const EdgeInsets.only(
              left: AppSpacing.md,
              top: AppSpacing.xs,
              right: AppSpacing.md,
            ),
            child: Text(
              'Notifications are disabled. Enable them in system settings to receive reminders.',
              style: AppFonts.body(
                size: 12,
                color: AppColors.redLight,
              ),
            ),
          ),
      ],
    );
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
          Expanded(
            child: Text(label, style: AppFonts.body(color: Colors.white)),
          ),
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
