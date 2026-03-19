// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) => UserSettings(
  hourlyReminders: json['hourlyReminders'] as bool,
  breathingReminders: json['breathingReminders'] as bool,
  soundEnabled: json['soundEnabled'] as bool,
  devicePreviewEnabled: json['devicePreviewEnabled'] as bool,
);

Map<String, dynamic> _$UserSettingsToJson(UserSettings instance) =>
    <String, dynamic>{
      'hourlyReminders': instance.hourlyReminders,
      'breathingReminders': instance.breathingReminders,
      'soundEnabled': instance.soundEnabled,
      'devicePreviewEnabled': instance.devicePreviewEnabled,
    };
