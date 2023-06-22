import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 2), () {
      navigateToScreen();
    });
  }

  void navigateToScreen() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? email = sharedPreferences.getString('email');

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (BuildContext context) => MyApp(email: email),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
