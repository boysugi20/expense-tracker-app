import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static Future initialize(FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
    var androidInit = const AndroidInitializationSettings('mipmap/expense_tracker');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: androidInit,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  static Future showNotification(
      {var id = 0,
      required String title,
      required String body,
      var payload,
      required FlutterLocalNotificationsPlugin fln}) async {
    AndroidNotificationDetails androidNotificationDetails = const AndroidNotificationDetails(
      'default_notification_channel_id',
      'Default',
      playSound: true,
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(''),
    );

    var not = NotificationDetails(android: androidNotificationDetails);

    // Generate a unique ID based on the current timestamp
    int id = DateTime.now().millisecondsSinceEpoch.hashCode;

    await fln.show(id, title, body, not);
    await Future.delayed(const Duration(seconds: 1));
  }
}
