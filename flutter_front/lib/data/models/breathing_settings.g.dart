// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'breathing_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BreathingSettings _$BreathingSettingsFromJson(Map<String, dynamic> json) =>
    BreathingSettings(
      durationMinutes: (json['durationMinutes'] as num).toInt(),
      mode: $enumDecode(_$BreathingModeEnumMap, json['mode']),
      soundEnabled: json['soundEnabled'] as bool,
    );

Map<String, dynamic> _$BreathingSettingsToJson(BreathingSettings instance) =>
    <String, dynamic>{
      'durationMinutes': instance.durationMinutes,
      'mode': _$BreathingModeEnumMap[instance.mode]!,
      'soundEnabled': instance.soundEnabled,
    };

const _$BreathingModeEnumMap = {
  BreathingMode.calm: 'calm',
  BreathingMode.energy: 'energy',
  BreathingMode.focus: 'focus',
};
