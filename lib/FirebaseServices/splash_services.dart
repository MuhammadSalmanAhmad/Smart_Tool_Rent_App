import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tool_rental_app/main.dart';

import '../Screens/HomeScreen/HomeScreen.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final auth = FirebaseAuth.instance;

    final user = auth.currentUser;
    if (user != null){
      Timer(
          Duration(seconds: 3),
              () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => HomeScreen())));
    }else{
      Timer(
          Duration(seconds: 3),
              () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => LaunchScreen())));
    }

  }
}
