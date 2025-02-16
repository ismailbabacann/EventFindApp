import 'dart:io';

import 'package:eventfindapp/screens/signup_page.dart';
import 'package:eventfindapp/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:eventfindapp/assets/theme/mycolors.dart';


class LoginPage extends StatelessWidget {

  final _tEmail= TextEditingController();
  final _tPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (Platform.isAndroid) {
          SystemNavigator.pop(); // Android için
        } else {
          exit(0); // iOS için
        }
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 100,),
                SvgPicture.asset(
                  'lib/assets/icons/logo_enyakın.svg',
                  height: 50,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 16),
                const Text(
                  'Hesabına giriş yap',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                const Text(
                  'Uygulamaya giriş yapmak için mail adresini gir',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _tEmail,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                    ),
                  ),
                ),
                SizedBox(height: 16),
                 TextField(
                  controller: _tPassword,
                  decoration: InputDecoration(
                    labelText: 'Şifre',
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                      AuthService().signIn(context, email: _tEmail.text, password: _tPassword.text);
                  },
                  child: Text('Giriş Yap' , style: TextStyle(color: Colors.white),),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: Divider()),
                    Text(" ya da "),
                    Expanded(child: Divider()),
                  ],
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    AuthService().signInWithGoogle(context);
                  },
                  icon: SvgPicture.asset('lib/assets/icons/google_icon.svg', height: 18),
                  label: Text(''),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[200],
                    side: BorderSide(color: Colors.white),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Giriş yap’a tıklayarak enYakın Hizmet Şartlarımızı ve Gizlilik Politikamızı kabul etmiş olursunuz.',
                  style: TextStyle(fontSize: 12 , color: Colors.blueGrey),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpPage()));
                  },
                  child: Text(
                    'Hesabın yok mu? Kaydolmak için tıkla!',
                    style: TextStyle(color: mainColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
