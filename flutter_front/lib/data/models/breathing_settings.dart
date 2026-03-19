import 'package:json_annotation/json_annotation.dart';

import '../../enums/enums.dart';

part 'breathing_settings.g.dart';

@JsonSerializable()
class BreathingSettings {
  const BreathingSettings({
    required this.durationMinutes,
    required this.mode,
    required this.soundEnabled,
  });

  factory BreathingSettings.fromJson(Map<String, dynamic> json) =>
      _$BreathingSettingsFromJson(json);

  final int durationMinutes;
  final BreathingMode mode;
  final bool soundEnabled;

  Map<String, dynamic> toJson() => _$BreathingSettingsToJson(this);

  factory BreathingSettings.defaults() => const BreathingSettings(
        durationMinutes: 3,
        mode: BreathingMode.calm,
        soundEnabled: true,
      );
}
