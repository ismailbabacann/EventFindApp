import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static SupabaseClient _supabaseClient = Supabase.instance.client;

  // Email ile giriş yap
  static Future<bool> signInWithEmail(String email, String password) async {
    try {
      final response = await _supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response.user != null;
    } catch (error) {
      print('Giriş hatası: $error');
      return false;
    }
  }


  /*
  // Google ile giriş yap
  static Future<bool> signInWithGoogle() async {
    try {
      final response = await _supabaseClient.auth.signInWithOAuth(Provider.google);
      return response.user != null;
    } catch (error) {
      print('Google ile giriş hatası: $error');
      return false;
    }
  }
  */

  // Email ile kayıt ol
  static Future<bool> signUpWithEmail(String name, String surname, String email, String password) async {
    try {
      final response = await _supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {
          'first_name': name,
          'last_name': surname,
        },
      );
      return response.user != null;
    } catch (error) {
      print('Kayıt hatası: $error');
      return false;
    }
  }

  // Şifre değiştirme
  static Future<bool> changePassword(String newPassword) async {
    try {
      final response = await _supabaseClient.auth.updateUser(UserAttributes(
        password: newPassword,
      ));
      return response.user != null;
    } catch (error) {
      print('Şifre değiştirme hatası: $error');
      return false;
    }
  }

  // Çıkış yap
  static Future<void> signOut() async {
    try {
      await _supabaseClient.auth.signOut();
    } catch (error) {
      print('Çıkış hatası: $error');
    }
  }
}
