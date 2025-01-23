import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("body : ${message.notification?.body}");
  if (message.notification != null) {
    final String? title = message.notification!.title;
    final String? body = message.notification!.body;

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'channel_id',
      'Channel Name',
      importance: Importance.high,
      priority: Priority.high,
    );
      const NotificationDetails notificationDetails = NotificationDetails(android: androidDetails);

    await flutterLocalNotificationsPlugin.show(
      message.hashCode, 
      title, 
      body, 
      notificationDetails,
    );
  }
  
}

class NotificationService {
  static final FirebaseMessaging messaging = FirebaseMessaging.instance;

  static Future<void> initialize() async {
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print('Notification permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message received: ${message.notification?.title}');
    });

    String? token = await messaging.getToken();
    print('FCM Token: $token');
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
  }
}
