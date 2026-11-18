import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzdata;

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    tzdata.initializeTimeZones();

    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(initSettings);
  }

  static Future<void> scheduleMaintenanceNotification({
    required int notificationId,
    required String title,
    required String body,
    required DateTime maintenanceDate,
  }) async {
    // Bir gün önce hatırlat
    final notificationTime = maintenanceDate.subtract(const Duration(days: 1));

    // Eğer geçmiş bir tarihse, planlama!
    if (notificationTime.isBefore(DateTime.now())) return;

    await _notifications.zonedSchedule(
      notificationId,
      title,
      body,
      tz.TZDateTime.from(notificationTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'maintenance_channel',
          'Bakım Hatırlatıcıları',
          channelDescription: 'Asansör bakım günü yaklaşınca hatırlatma',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  static Future<void> cancelNotification(int notificationId) async {
    await _notifications.cancel(notificationId);
  }
}
