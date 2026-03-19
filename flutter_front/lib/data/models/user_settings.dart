import 'package:json_annotation/json_annotation.dart';

part 'user_settings.g.dart';

@JsonSerializable()
class UserSettings {
  const UserSettings({
    required this.hourlyReminders,
    required this.breathingReminders,
    required this.soundEnabled,
    required this.devicePreviewEnabled,
  });

  factory UserSettings.defaults() => const UserSettings(
    hourlyReminders: true,
    breathingReminders: true,
    soundEnabled: false,
    devicePreviewEnabled: false,
  );

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);

  final bool hourlyReminders;
  final bool breathingReminders;
  final bool soundEnabled;
  final bool devicePreviewEnabled;

  Map<String, dynamic> toJson() => _$UserSettingsToJson(this);
}
