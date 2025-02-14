import 'dart:io';
import 'package:eventfindapp/assets/theme/mycolors.dart';
import 'package:eventfindapp/screens/feedback_page.dart';
import 'package:eventfindapp/screens/onboarding_page.dart'; // ✅ OnboardingPage import edildi
import 'package:eventfindapp/screens/password_change_page.dart';
import 'package:eventfindapp/screens/savedevents_page.dart';
import 'package:flutter/material.dart';
import 'package:eventfindapp/screens/pro_page.dart';
import 'package:eventfindapp/screens/login_page.dart';
import 'package:flutter_svg/flutter_svg.dart';

File? _globalImage;

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Column(
              children: [
                SizedBox(height: 50),
                Center(
                  child: SvgPicture.asset(
                    'lib/assets/icons/logo_enyakın.svg',
                    height: 60.0,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.bookmark, color: mainColor),
            title: Text('Kaydedilen Etkinlikler', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SavedEventsPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.my_library_books_outlined, color: mainColor),
            title: const Text('Kılavuz', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => OnboardingPage(isFromMenu: true), // ✅ Menüden açıldığını belirt
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.warning_rounded, color: mainColor),
            title: const Text('Destek', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FeedbackPage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: mainColor),
            title: const Text('Şifreyi Değiştir', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordChangePage()));
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app, color: mainColor),
            title: const Text('Çıkış Yap', style: TextStyle(fontWeight: FontWeight.bold)),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
            },
          ),
          ListTile(
            leading: SvgPicture.asset('lib/assets/icons/pro.svg'),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProPage()));
            },
          ),
          SizedBox(height: 40),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('lib/assets/icons/group_34057__5_.png', filterQuality: FilterQuality.high),
            ],
          ),
        ],
      ),
    );
  }
}
