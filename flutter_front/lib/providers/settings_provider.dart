import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

import '../data/local/prefs_store.dart';
import '../services/notification_service.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider({
    required NotificationService notificationService,
  }) : _notificationService = notificationService;

  final NotificationService _notificationService;

  bool _loaded = false;
  bool _hourlyReminders = true;
  bool _breathingReminders = true;
  bool _soundEnabled = false;
  bool _devicePreviewEnabled = false;
  PermissionStatus _notificationPermissionStatus = PermissionStatus.denied;
  bool _showHourlyWarning = false;
  bool _showBreathingWarning = false;

  bool get loaded => _loaded;
  bool get hourlyReminders => _hourlyReminders;
  bool get breathingReminders => _breathingReminders;
  bool get soundEnabled => _soundEnabled;
  bool get devicePreviewEnabled => _devicePreviewEnabled;
  bool get showHourlyWarning => _showHourlyWarning;
  bool get showBreathingWarning => _showBreathingWarning;
  bool get notificationsGranted => _notificationPermissionStatus.isGranted;
  bool get notificationsPermanentlyDenied =>
      _notificationPermissionStatus.isPermanentlyDenied;

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
    await refreshNotificationPermissionState(syncSchedules: true);
    notifyListeners();
  }

  Future<void> setHourlyReminders(bool value) async {
    if (_hourlyReminders == value) {
      return;
    }
    _hourlyReminders = value;
    if (!value) {
      _showHourlyWarning = false;
    }
    notifyListeners();
    await PrefsStore.instance.saveBool(PrefKeys.hourlyReminders, value);
    await _syncSchedules();
  }

  Future<void> setBreathingReminders(bool value) async {
    if (_breathingReminders == value) {
      return;
    }
    _breathingReminders = value;
    if (!value) {
      _showBreathingWarning = false;
    }
    notifyListeners();
    await PrefsStore.instance.saveBool(PrefKeys.breathingReminders, value);
    await _syncSchedules();
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

  Future<void> refreshNotificationPermissionState({
    bool syncSchedules = false,
  }) async {
    _notificationPermissionStatus = await _notificationService
        .notificationPermissionStatus();

    if (!_notificationPermissionStatus.isGranted) {
      if (_hourlyReminders) {
        _hourlyReminders = false;
        await PrefsStore.instance.saveBool(PrefKeys.hourlyReminders, false);
      }
      if (_breathingReminders) {
        _breathingReminders = false;
        await PrefsStore.instance.saveBool(PrefKeys.breathingReminders, false);
      }
    }

    if (syncSchedules) {
      await _syncSchedules();
    }

    notifyListeners();
  }

  Future<ReminderPermissionFlowResult> enableReminderAfterPermissionFlow(
    ReminderToggleType type,
  ) async {
    _notificationPermissionStatus = await _notificationService
        .requestNotificationPermission();

    if (_notificationPermissionStatus.isGranted) {
      if (type == ReminderToggleType.hourly) {
        _showHourlyWarning = false;
        await setHourlyReminders(true);
      } else {
        _showBreathingWarning = false;
        await setBreathingReminders(true);
      }
      return ReminderPermissionFlowResult.enabled;
    }

    if (type == ReminderToggleType.hourly) {
      _showHourlyWarning = true;
    } else {
      _showBreathingWarning = true;
    }
    notifyListeners();

    if (_notificationPermissionStatus.isPermanentlyDenied) {
      return ReminderPermissionFlowResult.openSettings;
    }

    return ReminderPermissionFlowResult.denied;
  }

  Future<void> clearPermissionWarning(ReminderToggleType type) async {
    if (type == ReminderToggleType.hourly) {
      _showHourlyWarning = false;
    } else {
      _showBreathingWarning = false;
    }
    notifyListeners();
  }

  Future<bool> openNotificationSettings() {
    return _notificationService.openSystemSettings();
  }

  Future<void> _syncSchedules() {
    return _notificationService.syncReminderSchedules(
      hourlyEnabled: _hourlyReminders && notificationsGranted,
      breathingEnabled: _breathingReminders && notificationsGranted,
    );
  }
}

enum ReminderToggleType {
  hourly,
  breathing,
}

enum ReminderPermissionFlowResult {
  enabled,
  denied,
  openSettings,
}
