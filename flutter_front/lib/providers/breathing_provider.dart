import 'package:flutter/foundation.dart';

import '../data/models/breathing_settings.dart';
import '../data/repositories/breathing_settings_repository.dart';

class BreathingProvider extends ChangeNotifier {
  BreathingProvider({
    required BreathingSettingsRepository repository,
  }) : _repository = repository;

  final BreathingSettingsRepository _repository;

  bool _loaded = false;
  BreathingSettings _settings = BreathingSettings.defaults();

  bool get loaded => _loaded;
  BreathingSettings get settings => _settings;

  Future<void> load() async {
    if (_loaded) {
      return;
    }
    _settings = await _repository.load();
    _loaded = true;
    notifyListeners();
  }

  Future<void> update(BreathingSettings settings) async {
    _settings = settings;
    notifyListeners();
    await _repository.save(settings);
  }
}
