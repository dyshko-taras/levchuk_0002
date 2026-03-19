import 'package:json_annotation/json_annotation.dart';

part 'user_settings.g.dart';

@JsonSerializable()
class UserSettings {
  const UserSettings({
    required this.hourlyReminders,
    required this.breathingReminders,
    required this.soundEnabled,
  });

  factory UserSettings.defaults() => const UserSettings(
    hourlyReminders: true,
    breathingReminders: true,
    soundEnabled: false,
  );

  factory UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);

  final bool hourlyReminders;
  final bool breathingReminders;
  final bool soundEnabled;

  Map<String, dynamic> toJson() => _$UserSettingsToJson(this);
}
