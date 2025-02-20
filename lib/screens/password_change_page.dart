import 'package:eventfindapp/assets/theme/mycolors.dart';
import 'package:flutter/material.dart';
import 'package:eventfindapp/services/auth_service.dart';
import 'package:eventfindapp/screens/password_change_page.dart';

class PasswordChangePage extends StatelessWidget {
  final _tOldPassword = TextEditingController();
  final _tNewPassword = TextEditingController();
  final _tConfirmPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          'Şifre Değiştir',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: mainColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              Text(
                'Şifrenizi Değiştirin',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _tOldPassword,
                decoration: InputDecoration(
                  labelText: 'Mevcut Şifre',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _tNewPassword,
                decoration: InputDecoration(
                  labelText: 'Yeni Şifre',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _tConfirmPassword,
                decoration: InputDecoration(
                  labelText: 'Yeni Şifreyi Onayla',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_tNewPassword.text == _tConfirmPassword.text) {
                    AuthService().changePassword(
                      oldPassword: _tOldPassword.text,
                      newPassword: _tNewPassword.text,
                      context: context,
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Yeni şifreler eşleşmiyor.')),
                    );
                  }
                },
                child: Text('Şifreyi Değiştir',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: mainColor,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
              SizedBox(height: 30,),
              ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: Image.asset(
                  'lib/assets/icons/International Kids Safe.png',
                  height: 300,
                  width: 300,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
