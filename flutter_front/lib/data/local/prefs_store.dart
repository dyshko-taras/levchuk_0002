import 'package:shared_preferences/shared_preferences.dart';

abstract final class PrefKeys {
  static const firstLaunch = 'app.is_first_launch';
  static const hourlyReminders = 'settings.hourly_reminders';
  static const breathingReminders = 'settings.breathing_reminders';
  static const soundEnabled = 'settings.sound_enabled';
  static const devicePreviewEnabled = 'settings.device_preview_enabled';
  static const demoDataEnabled = 'settings.demo_data_enabled';
  static const userProgress = 'storage.user_progress';
  static const breathingSettings = 'storage.breathing_settings';
  static const customWorkouts = 'storage.custom_workouts';
  static const quoteHistory = 'storage.quote_history';
}

class PrefsStore {
  PrefsStore._();

  static final instance = PrefsStore._();

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();

  Future<bool?> readBool(String key) async => (await _prefs).getBool(key);

  Future<void> saveBool(String key, {required bool value}) async {
    await (await _prefs).setBool(key, value);
  }

  Future<String?> readString(String key) async => (await _prefs).getString(key);

  Future<void> saveString(String key, String value) async {
    await (await _prefs).setString(key, value);
  }

  Future<void> remove(String key) async {
    await (await _prefs).remove(key);
  }
}
