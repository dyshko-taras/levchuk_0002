import 'package:shared_preferences/shared_preferences.dart';

abstract final class PrefKeys {
  static const firstLaunch = 'app.is_first_launch';
  static const hourlyReminders = 'settings.hourly_reminders';
  static const breathingReminders = 'settings.breathing_reminders';
  static const soundEnabled = 'settings.sound_enabled';
  static const devicePreviewEnabled = 'settings.device_preview_enabled';
}

class PrefsStore {
  PrefsStore._();

  static final instance = PrefsStore._();

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<bool?> readBool(String key) async => (await _prefs).getBool(key);

  Future<void> saveBool(String key, bool value) async {
    await (await _prefs).setBool(key, value);
  }
}
