import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  /// INIT (FIXED + SAFE)
  static Future<void> init() async {
    const AndroidInitializationSettings android =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: android);

    await _plugin.initialize(settings);

    // 🔥 Android 13+ permission fix
    final androidImpl = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    await androidImpl?.requestNotificationsPermission();
  }

  /// 💧 INSTANT WATER NOTIFICATION
  static Future<void> showWaterNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'water_channel',
      'Water Reminder',
      channelDescription: 'Reminds user to drink water',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await _plugin.show(
      0,
      "💧 Drink Water",
      "Stay hydrated! Add more water 💙",
      details,
    );
  }
}