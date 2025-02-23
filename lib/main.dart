import 'dart:io';
import 'package:eventfindapp/screens/login_page.dart';
import 'package:eventfindapp/screens/onboarding_page.dart';
import 'package:eventfindapp/screens/splash_page.dart';
import 'package:eventfindapp/services/eventnotification_service.dart';
import 'package:eventfindapp/services/firebase_messaging_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (Platform.isAndroid) {
    await Permission.notification.request();
  }

  await FirebaseMessagingService.initialize();
  EventNotificationService.startEventCheckTimer();
  print("✅ Uygulama Başladı! Bildirim Kontrolü Yapılıyor...");
  EventNotificationService.checkAndScheduleNotifications();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'enyakın',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: SplashPage(), // SplashPage ile başlat
      routes: {
        '/onboarding': (context) => OnboardingPage(),
        '/login': (context) => LoginPage(),
      },
    );
  }
}

