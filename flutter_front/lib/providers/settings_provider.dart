import 'package:flutter/foundation.dart';

import '../data/local/prefs_store.dart';

class SettingsProvider extends ChangeNotifier {
  bool _loaded = false;
  bool _hourlyReminders = true;
  bool _breathingReminders = true;
  bool _soundEnabled = false;
  bool _devicePreviewEnabled = false;

  bool get loaded => _loaded;
  bool get hourlyReminders => _hourlyReminders;
  bool get breathingReminders => _breathingReminders;
  bool get soundEnabled => _soundEnabled;
  bool get devicePreviewEnabled => _devicePreviewEnabled;

  Future<void> load() async {
    if (_loaded) {
      return;
    }

    _hourlyReminders =
        await PrefsStore.instance.readBool(PrefKeys.hourlyReminders) ?? true;
    _breathingReminders =
        await PrefsStore.instance.readBool(PrefKeys.breathingReminders) ?? true;
    _soundEnabled =
        await PrefsStore.instance.readBool(PrefKeys.soundEnabled) ?? false;
    _devicePreviewEnabled =
        await PrefsStore.instance.readBool(PrefKeys.devicePreviewEnabled) ??
            false;

    _loaded = true;
    notifyListeners();
  }

  Future<void> setHourlyReminders(bool value) async {
    if (_hourlyReminders == value) {
      return;
    }
    _hourlyReminders = value;
    notifyListeners();
    await PrefsStore.instance.saveBool(PrefKeys.hourlyReminders, value);
  }

  Future<void> setBreathingReminders(bool value) async {
    if (_breathingReminders == value) {
      return;
    }
    _breathingReminders = value;
    notifyListeners();
    await PrefsStore.instance.saveBool(PrefKeys.breathingReminders, value);
  }

  Future<void> setSoundEnabled(bool value) async {
    if (_soundEnabled == value) {
      return;
    }
    _soundEnabled = value;
    notifyListeners();
    await PrefsStore.instance.saveBool(PrefKeys.soundEnabled, value);
  }

  Future<void> setDevicePreviewEnabled(bool value) async {
    if (_devicePreviewEnabled == value) {
      return;
    }
    _devicePreviewEnabled = value;
    notifyListeners();
    await PrefsStore.instance.saveBool(PrefKeys.devicePreviewEnabled, value);
  }
}
