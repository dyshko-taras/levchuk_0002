import 'dart:async';
import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart' as app_settings;
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static const String payloadExercise = 'exercise';
  static const String payloadBreathing = 'breathing_focus';

  static const String _chIdLoud = 'active_office_reminders_loud_v1';
  static const String _chNameLoud = 'Reminders';
  static const String _chDescLoud = 'Reminder notifications with sound';

  static const String _chIdSilent = 'active_office_reminders_silent_v1';
  static const String _chNameSilent = 'Reminders (Silent)';
  static const String _chDescSilent = 'Reminder notifications without sound';

  static const String _androidSmallIcon = 'ic_notification_launcher';

  static const List<int> _hourlyReminderHours = <int>[
    9,
    10,
    11,
    12,
    13,
    14,
    15,
    16,
    17,
    18,
  ];

  static const List<int> _breathingReminderHours = <int>[
    10,
    12,
    14,
    16,
    18,
  ];

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  final StreamController<String> _payloadController =
      StreamController<String>.broadcast();

  bool _inited = false;
  String? _pendingPayload;

  Stream<String> get payloadStream => _payloadController.stream;

  String? consumePendingPayload() {
    final payload = _pendingPayload;
    _pendingPayload = null;
    return payload;
  }

  void _log(String message) {
    developer.log('[NotificationService] $message');
    debugPrint('[NotificationService] $message');
  }

  Future<void> init() async {
    if (_inited) {
      _log('Already initialized, skipping.');
      return;
    }

    tz_data.initializeTimeZones();
    const tzName = 'Europe/Kyiv';
    tz.setLocalLocation(tz.getLocation(tzName));
    _log('Timezone initialized: $tzName');

    const androidInit = AndroidInitializationSettings(_androidSmallIcon);
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    const initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        _log('Notification tapped: $payload');
        if (payload == null || payload.isEmpty) {
          return;
        }
        _payloadController.add(payload);
      },
    );

    final launchDetails = await _plugin.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      final payload = launchDetails?.notificationResponse?.payload;
      if (payload != null && payload.isNotEmpty) {
        _pendingPayload = payload;
      }
    }

    final android = _plugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin
    >();

    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        _chIdLoud,
        _chNameLoud,
        description: _chDescLoud,
        importance: Importance.high,
      ),
    );

    await android?.createNotificationChannel(
      const AndroidNotificationChannel(
        _chIdSilent,
        _chNameSilent,
        description: _chDescSilent,
        importance: Importance.high,
        playSound: false,
        enableVibration: false,
      ),
    );

    _inited = true;
    _log('Initialization completed.');
  }

  NotificationDetails _details({required bool withSound}) {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        withSound ? _chIdLoud : _chIdSilent,
        withSound ? _chNameLoud : _chNameSilent,
        channelDescription: withSound ? _chDescLoud : _chDescSilent,
        icon: _androidSmallIcon,
        importance: Importance.high,
        priority: Priority.high,
        enableVibration: withSound,
        playSound: withSound,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: withSound,
      ),
    );
  }

  Future<bool> areNotificationsEnabledSystem() async {
    final status = await app_settings.Permission.notification.status;
    final enabled = status.isGranted || status.isProvisional;
    _log('Permission status: ${status.name} -> enabled=$enabled');
    return enabled;
  }

  Future<app_settings.PermissionStatus> notificationPermissionStatus() {
    return app_settings.Permission.notification.status;
  }

  Future<bool> requestNotificationPermission() async {
    await init();
    final status = await app_settings.Permission.notification.request();
    final granted = status.isGranted || status.isProvisional;
    _log('Permission request result: ${status.name}');
    return granted;
  }

  Future<void> openAppSettings() async {
    _log('Opening app settings');
    await app_settings.openAppSettings();
  }

  Future<void> showTestNotification() async {
    await init();
    _log('Showing immediate test notification');
    await _plugin.show(
      999999,
      'ActiveOffice Test Notification',
      'If you can see this, local notifications are working.',
      _details(withSound: true),
      payload: 'test_notification',
    );
  }

  Future<void> syncReminderSchedules({
    required bool hourlyEnabled,
    required bool breathingEnabled,
    required bool soundEnabled,
  }) async {
    await init();
    _log(
      'Sync schedules: hourly=$hourlyEnabled, '
      'breathing=$breathingEnabled, sound=$soundEnabled',
    );

    await cancelReminderSchedules();

    if (hourlyEnabled) {
      for (final hour in _hourlyReminderHours) {
        await _scheduleDailyReminder(
          id: 100 + hour,
          hour: hour,
          title: "It's time to stretch!",
          body: 'Open your hourly movement break and reset your posture.',
          payload: '$payloadExercise:$hour',
          withSound: soundEnabled,
        );
      }
    }

    if (breathingEnabled) {
      for (final hour in _breathingReminderHours) {
        await _scheduleDailyReminder(
          id: 200 + hour,
          hour: hour,
          title: 'Take a 3-minute breathing break.',
          body: 'Open Focus Breathing and refocus your energy.',
          payload: payloadBreathing,
          withSound: soundEnabled,
        );
      }
    }
  }

  Future<void> cancelReminderSchedules() async {
    _log('Cancelling reminder schedules');
    for (final hour in _hourlyReminderHours) {
      await _plugin.cancel(100 + hour);
    }
    for (final hour in _breathingReminderHours) {
      await _plugin.cancel(200 + hour);
    }
  }

  Future<void> _scheduleDailyReminder({
    required int id,
    required int hour,
    required String title,
    required String body,
    required String payload,
    required bool withSound,
  }) async {
    final scheduledAt = _nextInstanceOfHour(hour);
    _log('Scheduling id=$id at $scheduledAt payload=$payload');

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduledAt,
      _details(withSound: withSound),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: payload,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextInstanceOfHour(int hour) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
    );

    if (!scheduled.isAfter(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }
}
