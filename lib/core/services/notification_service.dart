import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../../data/models/task_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  bool notificationsEnabled = true;

  Future<void> init() async {
    if (_initialized) return;

    try {
      tz.initializeTimeZones();
      final tzInfo = await FlutterTimezone.getLocalTimezone();
      final timeZoneName = tzInfo.identifier;
      tz.setLocalLocation(tz.getLocation(timeZoneName));
    } catch (e) {
      debugPrint('Error configuring timezone: $e');
      // Fallback
      try {
        tz.setLocalLocation(tz.getLocation('UTC'));
      } catch (_) {}
    }

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (response) {
        debugPrint('Notification clicked: ${response.payload}');
      },
    );

    _initialized = true;
  }

  Future<bool> requestPermissions() async {
    if (!_initialized) await init();

    try {
      final androidImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      if (androidImplementation != null) {
        final granted =
            await androidImplementation.requestNotificationsPermission();
        return granted ?? false;
      }

      final iosImplementation =
          _notificationsPlugin.resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>();

      if (iosImplementation != null) {
        final granted = await iosImplementation.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return granted ?? false;
      }
    } catch (e) {
      debugPrint('Error requesting notification permissions: $e');
    }
    return false;
  }

  Future<void> scheduleTaskNotification(TaskModel task) async {
    if (!notificationsEnabled || task.id == null || task.isCompleted || task.isSkipped) {
      return;
    }

    final taskStartTime = task.startDateTime;
    final now = DateTime.now();

    if (taskStartTime.isBefore(now)) {
      return; // Already past
    }

    final scheduledTzTime = tz.TZDateTime.from(taskStartTime, tz.local);

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'kikorbo_tasks_channel',
      'Task Reminders',
      channelDescription: 'Notifications for scheduled tasks',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    try {
      await _notificationsPlugin.zonedSchedule(
        id: task.id!,
        title: 'KiKorbo?',
        body: "It's time for ${task.title} ${task.emoji}",
        scheduledDate: scheduledTzTime,
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        payload: task.id.toString(),
      );
    } catch (e) {
      // In case exact alarm permission is not granted on newer Android, fallback to inexact
      try {
        await _notificationsPlugin.zonedSchedule(
          id: task.id!,
          title: 'KiKorbo?',
          body: "It's time for ${task.title} ${task.emoji}",
          scheduledDate: scheduledTzTime,
          notificationDetails: notificationDetails,
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          payload: task.id.toString(),
        );
      } catch (err) {
        debugPrint('Failed to schedule notification: $err');
      }
    }
  }

  Future<void> cancelTaskNotification(int taskId) async {
    try {
      await _notificationsPlugin.cancel(id: taskId);
    } catch (e) {
      debugPrint('Error canceling notification: $e');
    }
  }

  Future<void> showTimerCompleteNotification({
    required String taskTitle,
    required bool isBreak,
  }) async {
    if (!notificationsEnabled) return;

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'kikorbo_timer_channel',
      'Timer Alerts',
      channelDescription: 'Notifications when focus or break timers complete',
      importance: Importance.high,
      priority: Priority.high,
      enableVibration: true,
      playSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    final title = 'KiKorbo?';
    final body = isBreak
        ? "Break's over. Ready to focus again?"
        : "Your focus session for '$taskTitle' is finished! 🎉";

    await _notificationsPlugin.show(
      id: 99999,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );
  }

  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }
}
