import 'package:flutter/foundation.dart';

import '../data/local/prefs_store.dart';

class AppBootstrapProvider extends ChangeNotifier {
  bool _initialized = false;
  bool _isFirstLaunch = true;

  bool get initialized => _initialized;
  bool get isFirstLaunch => _isFirstLaunch;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    _isFirstLaunch =
        await PrefsStore.instance.readBool(PrefKeys.firstLaunch) ?? true;
    _initialized = true;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _isFirstLaunch = false;
    notifyListeners();
    await PrefsStore.instance.saveBool(PrefKeys.firstLaunch, false);
  }
}
