import 'package:eventfindapp/screens/mainpage.dart';
import 'package:eventfindapp/services/supabase_service.dart';
import 'package:flutter/material.dart';
import 'package:eventfindapp/assets/theme/mycolors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignUpPage extends StatelessWidget {
  final _tName = TextEditingController();
  final _tSurname = TextEditingController();
  final _tEmail = TextEditingController();
  final _tPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'lib/assets/icons/logo_enyakın.svg',
                  height: 45.0,
                  fit: BoxFit.cover,
                ),
                SizedBox(height: 16),
                Text(
                  'Hesap oluştur',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Uygulamaya kaydolmak için bilgilerini gir',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _tName,
                  decoration: InputDecoration(
                    labelText: 'İsim',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _tSurname,
                  decoration: InputDecoration(
                    labelText: 'Soyisim',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _tEmail,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
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
                  onPressed: () async {
                    String name = _tName.text.trim();
                    String surname = _tSurname.text.trim();
                    String email = _tEmail.text.trim();
                    String password = _tPassword.text.trim();

                    bool success = await SupabaseService.signUpWithEmail(name, surname, email, password);

                    if (success) {
                      // Başarılı kayıt, giriş sayfasına yönlendirme yapabilirsiniz
                      Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage() ));
                    } else {
                      // Başarısız kayıt, hata mesajı gösterme
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Kayıt başarısız, bilgilerinizi kontrol edin.')),
                      );
                    }
                  },
                  child: Text(
                    'Kaydol',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Kaydol’a tıklayarak enYakın Hizmet Şartlarımızı ve Gizlilik Politikamızı kabul etmiş olursunuz.',
                  style: TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Hesabın mı var? Giriş Yap',
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
