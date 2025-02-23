import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'firebase_messaging_service.dart';

class EventNotificationService {
  static Timer? _timer;

  static void startEventCheckTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(hours: 1), (timer) {
      checkAndScheduleNotifications();
    });
  }

  static Future<void> checkAndScheduleNotifications() async {
    print(" Bildirim kontrolü başlatıldı!");
    final now = DateTime.now();
    final User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("Kullanıcı oturum açmamış!");
      return;
    }

    final snapshot = await FirebaseFirestore.instance
        .collection('saved_events')
        .doc(user.uid)
        .collection('events')
        .get();

    if (snapshot.docs.isEmpty) {
      print(" Kullanıcının kaydettiği etkinlik yok!");
      return;
    }

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>?;
      if (data == null) continue;

      final name = data['name']?.toString() ?? 'Bilinmiyor';
      final location = data['location']?.toString() ?? 'Bilinmeyen Yer';
      final localDate = data['localDate']?.toString() ?? '';
      final localTime = data['localTime']?.toString() ?? '';

      DateTime? eventDateTime = _parseDateTime(localDate, localTime);
      if (eventDateTime != null) {
        print("🕒 Etkinlik bulundu: $name - $eventDateTime");

        // 1 gün önce bildirim
        DateTime oneDayBefore = eventDateTime.subtract(Duration(days: 1));
        if (oneDayBefore.isAfter(now)) {
          print("📅 1 gün önce bildirim planlanıyor: $name - $oneDayBefore");
          await FirebaseMessagingService.scheduleNotification(
            id: doc.hashCode,
            title: "Yaklaşan Etkinlik: $name",
            body: "📍 $location | Etkinlik yarın başlayacak!",
            scheduledTime: oneDayBefore,
          );
        }

        // 1 saat önce bildirim
        DateTime oneHourBefore = eventDateTime.subtract(Duration(hours: 1));
        if (oneHourBefore.isAfter(now)) {
          print("⏳ 1 saat önce bildirim planlanıyor: $name - $oneHourBefore");
          await FirebaseMessagingService.scheduleNotification(
            id: doc.hashCode + 1,
            title: "Yaklaşan Etkinlik: $name",
            body: "📍 $location | Etkinlik 1 saat içinde başlayacak!",
            scheduledTime: oneHourBefore,
          );
        }
      }
    }
  }

  static DateTime? _parseDateTime(String date, String time) {
    try {
      final formattedDate = DateFormat('yyyy-MM-dd').parse(date);
      final formattedTime = DateFormat('HH:mm').parse(time);
      return DateTime(
        formattedDate.year,
        formattedDate.month,
        formattedDate.day,
        formattedTime.hour,
        formattedTime.minute,
      );
    } catch (e) {
      print(" Tarih dönüşüm hatası: $e");
      return null;
    }
  }
}
