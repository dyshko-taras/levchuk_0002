import 'package:flutter/foundation.dart';

import '../data/local/prefs_store.dart';

enum AppBootstrapStatus {
  idle,
  loading,
  ready,
}

class AppBootstrapProvider extends ChangeNotifier {
  AppBootstrapStatus _status = AppBootstrapStatus.idle;
  bool _initialized = false;
  bool _isFirstLaunch = true;

  AppBootstrapStatus get status => _status;
  bool get initialized => _initialized;
  bool get isFirstLaunch => _isFirstLaunch;
  bool get isReady => _status == AppBootstrapStatus.ready;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    _status = AppBootstrapStatus.loading;
    notifyListeners();

    _isFirstLaunch =
        await PrefsStore.instance.readBool(PrefKeys.firstLaunch) ?? true;
    _initialized = true;
    _status = AppBootstrapStatus.ready;
    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    _isFirstLaunch = false;
    notifyListeners();
    await PrefsStore.instance.saveBool(PrefKeys.firstLaunch, false);
  }
}
