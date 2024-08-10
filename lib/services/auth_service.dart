import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eventfindapp/screens/mainpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService{

  final userCollection=FirebaseFirestore.instance.collection("users");
  final firebaseAuth = FirebaseAuth.instance;

  Future<void> signUp(BuildContext context ,{required String name,required String surname, required String email , required String password}) async{
   try {
     final UserCredential userCredential =  await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
     if(userCredential.user != null){
      await _registerUser(name: name, surname: surname, email: email, password: password);
      Fluttertoast.showToast(msg: "BAŞARIYLA KAYIT YAPTINIZ! ", toastLength: Toast.LENGTH_LONG);
      Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
     }
   } on FirebaseAuthException catch (e){
     Fluttertoast.showToast(msg: e.message! , toastLength: Toast.LENGTH_LONG);
   }
  }

  Future<void> signIn(BuildContext context , {required String email , required String password}) async {
    try {
    final UserCredential userCredential = await firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    if(userCredential.user != null){
      Fluttertoast.showToast(msg: "BAŞARIYLA GİRİŞ YAPTINIZ! ", toastLength: Toast.LENGTH_LONG);
      Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
    }
  } on FirebaseAuthException catch (e) {
    Fluttertoast.showToast(msg: e.message! , toastLength: Toast.LENGTH_LONG);
  }
  }

  Future<void> _registerUser({required String name,required String surname, required String email , required String password}) async {
    await userCollection.doc().set({
        "email": email,
        "name": name,
        "surname": surname,
        "password": password,
    }

    );


  }

}