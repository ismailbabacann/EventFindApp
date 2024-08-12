import 'package:eventfindapp/screens/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:eventfindapp/screens/mainpage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


const supabaseUrl = 'https://erptonkeyuqanosneonn.supabase.co';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImVycHRvbmtleXVxYW5vc25lb25uIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MjM0NTQ1ODUsImV4cCI6MjAzOTAzMDU4NX0.wgbA7Jy5MGoAx6mTHgLicDwONFNhdhdRNfpOtqmxWco',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginPage() ,
    );
  }
}
