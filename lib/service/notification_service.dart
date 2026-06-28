import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// INIT (FIXED + SAFE)
  static Future<void> init() async {
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: androidInit);

    await _plugin.initialize(settings);

    // Android 13+ permission fix (SAFE CAST)
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidImpl?.requestNotificationsPermission();
  }

  /// INSTANT NOTIFICATION
  static Future<void> showWaterNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'water_channel',
      'Water Reminders',
      channelDescription: 'Instant water notification',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await _plugin.show(
      0,
      '💧 AquaNova',
      'Drink water now!',
      details,
    );
  }

  /// ⏰ HOURLY REPEATING REMINDER (FIXED LOGIC)
  static Future<void> scheduleHourlyReminder() async {
    await _plugin.zonedSchedule(
      1,
      '💧 Water Reminder',
      'Time to drink water!',
      _nextHour(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Reminders',
          channelDescription: 'Hourly water reminder',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

      // FIXED: correct repeat behavior
      matchDateTimeComponents: DateTimeComponents.hourly,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// DAILY REMINDER (FIXED BEST PRACTICE)
  static Future<void> scheduleDailyReminder() async {
    await _plugin.zonedSchedule(
      2,
      '💧 Drink Water',
      'Stay hydrated today!',
      _nextInstanceOfHour(9),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_channel',
          'Daily Reminder',
          channelDescription: 'Daily water reminder',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

      // FIXED: correct daily repeat
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// 🔥 FIXED NEXT HOUR FUNCTION (clean logic)
  static tz.TZDateTime _nextHour() {
    final now = tz.TZDateTime.now(tz.local);
    return tz.TZDateTime(tz.local, now.year, now.month, now.day, now.hour + 1);
  }

  /// helper for specific hour
  static tz.TZDateTime _nextInstanceOfHour(int hour) {
    final now = tz.TZDateTime.now(tz.local);

    tz.TZDateTime scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour);

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }

  /// CANCEL ALL NOTIFICATIONS
  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }
}