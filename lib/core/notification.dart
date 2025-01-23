import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rx_shared_preferences/rx_shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  
  static Future<void> onDidReceiveNotificationResponse(NotificationResponse notificationResponse) async {
  }

  static Future<void> init() async {
    const AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings("@mipmap/ic_launcher");
    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
    onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    onDidReceiveBackgroundNotificationResponse: onDidReceiveNotificationResponse);

    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.requestNotificationsPermission();
  }

  static Future<void> scheduleNotification(String title, String body, DateTime scheduledDate) async {
    const NotificationDetails platformChannelSpecificis = NotificationDetails(
      android: AndroidNotificationDetails("channel_id", "channel_Name", importance: Importance.high, priority: Priority.high)
    );
    await flutterLocalNotificationsPlugin.zonedSchedule(0, title, body, tz.TZDateTime.from(scheduledDate, tz.local), platformChannelSpecificis,
     uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime, matchDateTimeComponents: DateTimeComponents.dateAndTime, androidScheduleMode: AndroidScheduleMode.exact);
  }


  static Future<void> showInstantNotification(String title, String body) async {
    const NotificationDetails platformChannelSpecificis = NotificationDetails(
      android: AndroidNotificationDetails("channel_id", "channel_Name", importance: Importance.high, priority: Priority.high)
    );
    await flutterLocalNotificationsPlugin.show(0, title, body, platformChannelSpecificis);
  }

  static Future<void> checkAndScheduleReminders() async {
    final prefs = await SharedPreferences.getInstance();
    print("ajunge aici sa verifice");
    // Retrieve the last jogging timestamp
    final String? dateString = prefs.getString('lastJoggingTime');
    if (dateString == null) return;
    print(dateString);
    print("rezultatul nu e null");
    final lastJoggingTime = DateTime.parse(dateString);
    final now = DateTime.now();

    // Schedule 3-day reminder
    if (now.difference(lastJoggingTime).inDays >= 3) {
      await NotificationService.scheduleNotification(
        "Jogging Reminder",
        "It’s been 3 days since your last jog. Stay active!",
        now.add(const Duration(seconds: 10)), // Example: Immediate trigger for testing
      );
    }
    if (now.difference(lastJoggingTime).inDays >= 7) {
      await NotificationService.scheduleNotification(
        "Jogging Reminder",
        "It’s been a week since your last jog! Time to get moving!",
        now.add(const Duration(seconds: 10)), // Example: Immediate trigger for testing
      );
    }
  }
}