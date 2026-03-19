import 'package:FlutterApp/constants/app_spacing.dart';
import 'package:FlutterApp/data/models/breathing_settings.dart';
import 'package:FlutterApp/enums/enums.dart';
import 'package:FlutterApp/providers/breathing_provider.dart';
import 'package:FlutterApp/ui/theme/app_colors.dart';
import 'package:FlutterApp/ui/theme/app_fonts.dart';
import 'package:FlutterApp/ui/widgets/common/screen_header.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BreathingSettingsPage extends StatefulWidget {
  const BreathingSettingsPage({super.key});

  @override
  State<BreathingSettingsPage> createState() => _BreathingSettingsPageState();
}

class _BreathingSettingsPageState extends State<BreathingSettingsPage> {
  static const _durations = [1, 3, 5, 10];

  bool _initialized = false;
  late int _durationMinutes;
  late BreathingMode _mode;
  late bool _soundEnabled;

  bool get _hasChanges {
    final settings = context.read<BreathingProvider>().settings;
    return _durationMinutes != settings.durationMinutes ||
        _mode != settings.mode ||
        _soundEnabled != settings.soundEnabled;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) {
      return;
    }

    final settings = context.read<BreathingProvider>().settings;
    _durationMinutes = settings.durationMinutes;
    _mode = settings.mode;
    _soundEnabled = settings.soundEnabled;
    _initialized = true;
  }

  Future<void> _applyChanges() async {
    final provider = context.read<BreathingProvider>();
    final hasActiveSession =
        provider.sessionRunning ||
        provider.remainingSeconds > 0 ||
        provider.sessionCompleted;

    await provider.update(
      BreathingSettings(
        durationMinutes: _durationMinutes,
        mode: _mode,
        soundEnabled: _soundEnabled,
      ),
    );

    if (hasActiveSession) {
      provider.stopSession();
    }

    if (!mounted) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          hasActiveSession
              ? 'Breathing session stopped. New settings applied.'
              : 'Breathing settings applied.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    context.watch<BreathingProvider>();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const ScreenHeader(
              title: 'Settings Panel',
              showClose: true,
            ),
            Expanded(
              child: ListView(
                padding: Insets.screen,
                children: [
                  Text(
                    'Duration, (min):',
                    style: AppFonts.body(color: AppColors.textGray),
                  ),
                  Gaps.hSm,
                  Row(
                    children: _durations
                        .map(
                          (duration) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: AppSpacing.xs,
                              ),
                              child: _SelectChip(
                                label: '$duration',
                                selected: _durationMinutes == duration,
                                onTap: () {
                                  setState(() {
                                    _durationMinutes = duration;
                                  });
                                },
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  Gaps.hLg,
                  Text(
                    'Mode:',
                    style: AppFonts.body(color: AppColors.textGray),
                  ),
                  Gaps.hSm,
                  Row(
                    children: BreathingMode.values
                        .map(
                          (mode) => Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: AppSpacing.xs,
                              ),
                              child: _SelectChip(
                                label: _modeLabel(mode),
                                selected: _mode == mode,
                                onTap: () {
                                  setState(() {
                                    _mode = mode;
                                  });
                                },
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  Gaps.hLg,
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.darkCard,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Sound:',
                            style: AppFonts.body(color: Colors.white),
                          ),
                        ),
                        Switch(
                          value: _soundEnabled,
                          activeThumbColor: AppColors.greenStart,
                          onChanged: (value) {
                            setState(() {
                              _soundEnabled = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                  Gaps.hXl,
                  FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.greenStart,
                      minimumSize: const Size.fromHeight(54),
                    ),
                    onPressed: _hasChanges ? _applyChanges : null,
                    child: Text(
                      'Apply Changes',
                      style: AppFonts.body(
                        weight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Gaps.hSm,
                  Text(
                    'Applying new settings will stop the current breathing '
                    'session if one is active.',
                    style: AppFonts.body(
                      size: 12,
                      color: AppColors.textGray,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _modeLabel(BreathingMode mode) {
    switch (mode) {
      case BreathingMode.calm:
        return 'Calm';
      case BreathingMode.energy:
        return 'Energy';
      case BreathingMode.focus:
        return 'Focus';
    }
  }
}

class _SelectChip extends StatelessWidget {
  const _SelectChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        backgroundColor: selected
            ? AppColors.greenStart
            : AppColors.darkCard,
        minimumSize: const Size.fromHeight(52),
      ),
      onPressed: onTap,
      child: Text(
        label,
        textAlign: TextAlign.center,
        style: AppFonts.body(
          weight: selected ? FontWeight.w700 : FontWeight.w400,
          color: selected ? Colors.white : AppColors.textGray,
        ),
      ),
    );
  }
}
