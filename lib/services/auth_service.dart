import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventfindapp/screens/mainpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final userCollection = FirebaseFirestore.instance.collection("users");
  final firebaseAuth = FirebaseAuth.instance;

  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await firebaseAuth.signInWithCredential(credential);

      if (userCredential.user != null) {
        Fluttertoast.showToast(
            msg: "Google ile giriş başarılı! ", toastLength: Toast.LENGTH_LONG);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainPage()));
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!, toastLength: Toast.LENGTH_LONG);
    } catch (e) {
      Fluttertoast.showToast(
          msg: "Bir hata oluştu: $e", toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<void> signUp(BuildContext context,
      {required String name,
      required String surname,
      required String email,
      required String password}) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        await _registerUser(
            name: name, surname: surname, email: email, password: password);
        Fluttertoast.showToast(
            msg: "BAŞARIYLA KAYIT YAPTINIZ! ", toastLength: Toast.LENGTH_LONG);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainPage()));
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!, toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<void> signIn(BuildContext context,
      {required String email, required String password}) async {
    try {
      final UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        Fluttertoast.showToast(
            msg: "BAŞARIYLA GİRİŞ YAPTINIZ! ", toastLength: Toast.LENGTH_LONG);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => MainPage()));
      }
    } on FirebaseAuthException catch (e) {
      Fluttertoast.showToast(msg: e.message!, toastLength: Toast.LENGTH_LONG);
    }
  }

  Future<void> _registerUser(
      {required String name,
      required String surname,
      required String email,
      required String password}) async {
    await userCollection.doc().set({
      "email": email,
      "name": name,
      "surname": surname,
      "password": password,
    });
  }

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required BuildContext context,
  }) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Kullanıcı girişi yapılmamış.')),
      );
      return;
    }

    try {
      // Şu anda giriş yapmış kullanıcının şifresini değiştirmek için önce mevcut şifreyi doğrulamamız gerekiyor
      final credentials = EmailAuthProvider.credential(
        email: user.email!,
        password: oldPassword,
      );

      await user.reauthenticateWithCredential(credentials);
      await user.updatePassword(newPassword);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Şifre başarıyla değiştirildi.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Şifre değiştirilemedi: $e')),
      );
    }
  }
}
