import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static Future initialize(
      FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) async {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
    var androidInit =
        const AndroidInitializationSettings('mipmap/expense_tracker');
    var initializationSettingsDarwin = const DarwinInitializationSettings();
    final InitializationSettings initializationSettings =
        InitializationSettings(
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
    AndroidNotificationDetails androidNotificationDetails =
        const AndroidNotificationDetails(
      'default_notification_channel_id',
      'Default',

      playSound: true,
      // sound: RawResourceAndroidNotificationSound('notification'),
      importance: Importance.max,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(''),
    );

    var not = NotificationDetails(android: androidNotificationDetails);

    await fln.show(0, title, body, not);
  }
}
