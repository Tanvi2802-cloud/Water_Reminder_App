import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future init() async {
    const android = AndroidInitializationSettings('@mipmap/ic_launcher');

    const settings = InitializationSettings(android: android);

    await _plugin.initialize(settings);
  }

  static Future showWaterNotification() async {
    const androidDetails = AndroidNotificationDetails(
      'water_channel',
      'Water Reminder',
      channelDescription: 'Reminds user to drink water',
      importance: Importance.max,
      priority: Priority.high,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      0,
      "💧 Drink Water",
      "Stay hydrated! Add more water 💙",
      details,
    );
  }
}