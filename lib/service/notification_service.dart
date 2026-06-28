import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  static Future init() async {
    const AndroidInitializationSettings android =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: android);

    await plugin.initialize(settings);
  }

  static Future showWaterNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'water_channel',
      'Water Reminder',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await plugin.show(
      0,
      "💧 Drink Water",
      "Stay hydrated!",
      details,
    );
  }
}