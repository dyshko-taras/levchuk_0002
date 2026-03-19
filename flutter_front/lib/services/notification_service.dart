import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  static const _hourlyChannelId = 'hourly_reminders';
  static const _breathingChannelId = 'breathing_reminders';
  static const _payloadExercise = 'exercise';
  static const _payloadBreathing = 'breathing_focus';

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  final StreamController<String> _payloadController =
      StreamController<String>.broadcast();

  bool _initialized = false;
  String? _pendingPayload;

  Stream<String> get payloadStream => _payloadController.stream;

  String? consumePendingPayload() {
    final payload = _pendingPayload;
    _pendingPayload = null;
    return payload;
  }

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    tz.initializeTimeZones();
    final timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('ic_launcher'),
    );

    await _plugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _handleNotificationResponse,
    );

    final launchDetails = await _plugin.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      final payload = launchDetails?.notificationResponse?.payload;
      if (payload != null && payload.isNotEmpty) {
        _pendingPayload = payload;
      }
    }

    await _createChannels();
    _initialized = true;
  }

  Future<PermissionStatus> notificationPermissionStatus() {
    return Permission.notification.status;
  }

  Future<PermissionStatus> requestNotificationPermission() {
    return Permission.notification.request();
  }

  Future<bool> openSystemSettings() => openAppSettings();

  Future<void> syncReminderSchedules({
    required bool hourlyEnabled,
    required bool breathingEnabled,
  }) async {
    await cancelReminderSchedules();

    if (hourlyEnabled) {
      for (var hour = 9; hour <= 18; hour++) {
        await _scheduleDailyReminder(
          id: 100 + hour,
          hour: hour,
          minute: 0,
          title: 'It\'s time to stretch!',
          body: 'Open your hourly movement break and reset your posture.',
          payload: '$_payloadExercise:$hour',
          channelId: _hourlyChannelId,
          channelName: 'Hourly Stretch Reminders',
          channelDescription: 'Stretch reminders during the workday',
        );
      }
    }

    if (breathingEnabled) {
      for (final hour in [10, 12, 14, 16, 18]) {
        await _scheduleDailyReminder(
          id: 200 + hour,
          hour: hour,
          minute: 0,
          title: 'Take a 3-minute breathing break.',
          body: 'Open Focus Breathing and refocus your energy.',
          payload: _payloadBreathing,
          channelId: _breathingChannelId,
          channelName: 'Breathing Reminders',
          channelDescription: 'Breathing reminders during the workday',
        );
      }
    }
  }

  Future<void> cancelReminderSchedules() async {
    for (var hour = 9; hour <= 18; hour++) {
      await _plugin.cancel(100 + hour);
    }
    for (final hour in [10, 12, 14, 16, 18]) {
      await _plugin.cancel(200 + hour);
    }
  }

  Future<void> _createChannels() async {
    final androidImplementation = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidImplementation == null) {
      return;
    }

    await androidImplementation.createNotificationChannel(
      const AndroidNotificationChannel(
        _hourlyChannelId,
        'Hourly Stretch Reminders',
        description: 'Stretch reminders during the workday',
        importance: Importance.high,
      ),
    );

    await androidImplementation.createNotificationChannel(
      const AndroidNotificationChannel(
        _breathingChannelId,
        'Breathing Reminders',
        description: 'Breathing reminders during the workday',
        importance: Importance.high,
      ),
    );
  }

  Future<void> _scheduleDailyReminder({
    required int id,
    required int hour,
    required int minute,
    required String title,
    required String body,
    required String payload,
    required String channelId,
    required String channelName,
    required String channelDescription,
  }) async {
    final scheduledAt = _nextDailyInstance(hour, minute);

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      scheduledAt,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channelId,
          channelName,
          channelDescription: channelDescription,
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      payload: payload,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  tz.TZDateTime _nextDailyInstance(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }

  void _handleNotificationResponse(NotificationResponse response) {
    final payload = response.payload;
    if (payload == null || payload.isEmpty) {
      return;
    }
    _payloadController.add(payload);
  }
}
