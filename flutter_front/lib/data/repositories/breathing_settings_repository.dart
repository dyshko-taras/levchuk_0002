import 'dart:convert';

import 'package:FlutterApp/data/local/prefs_store.dart';
import 'package:FlutterApp/data/models/breathing_settings.dart';

class BreathingSettingsRepository {
  BreathingSettingsRepository({
    PrefsStore? prefsStore,
  }) : _prefsStore = prefsStore ?? PrefsStore.instance;

  final PrefsStore _prefsStore;

  Future<BreathingSettings> load() async {
    final raw = await _prefsStore.readString(PrefKeys.breathingSettings);
    if (raw == null || raw.isEmpty) {
      return BreathingSettings.defaults();
    }

    return BreathingSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> save(BreathingSettings settings) async {
    await _prefsStore.saveString(
      PrefKeys.breathingSettings,
      jsonEncode(settings.toJson()),
    );
  }
}
