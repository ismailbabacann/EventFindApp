import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class FirebaseMessagingService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
  FlutterLocalNotificationsPlugin();


  static Future<void> initialize() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
    InitializationSettings(android: androidSettings);

    await _notificationsPlugin.initialize(settings);

    tz.initializeTimeZones();

    if (Platform.isAndroid && await _needsExactAlarmPermission()) {
      await _requestExactAlarmPermission();
    }
  }

  static Future<bool> _needsExactAlarmPermission() async {
    return !(await Permission.scheduleExactAlarm.isGranted);
  }

  static Future<void> _requestExactAlarmPermission() async {
    await Permission.scheduleExactAlarm.request();
  }

  //(DateTime → TZDateTime)**
  static tz.TZDateTime _convertToTZ(DateTime dateTime) {
    return tz.TZDateTime.from(dateTime, tz.local);
  }


  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
  }) async {
    print("🔔 Bildirim Planlanıyor: $title - $scheduledTime");

    final androidDetails = AndroidNotificationDetails(
      'event_channel',
      'Etkinlik Hatırlatma',
      channelDescription: 'Kaydedilen etkinliklerden bildirim gönderir',
      importance: Importance.max,
      priority: Priority.high,
    );

    final details = NotificationDetails(android: androidDetails);

    await _notificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _convertToTZ(scheduledTime),
      details,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
    print("✅ Bildirim planlandı: $title - ${_convertToTZ(scheduledTime)}");
  }

  static Future<void> testNotification() async {
    await _notificationsPlugin.show(
      0,
      "📢 Test Bildirimi",
      "Bu bir test mesajıdır!",
      NotificationDetails(
        android: AndroidNotificationDetails(
          'test_channel',
          'Test Bildirimi',
          channelDescription: 'Test için bir bildirim gönderildi.',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
    print("✅ Test bildirimi gönderildi!");
  }

}
