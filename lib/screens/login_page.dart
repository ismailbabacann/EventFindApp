import 'package:eventfindapp/screens/mainpage.dart';
import 'package:eventfindapp/screens/signup_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Color mainColor = Color(0xFF6D3B8C);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'lib/assets/icons/resim_2024_08_04_181249667_photoroom.png',
                height: 45.0,
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
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              const TextField(
                decoration: InputDecoration(
                  labelText: 'Şifre',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
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
                  // Google ile giriş ayarlancak
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
    );
  }
}
