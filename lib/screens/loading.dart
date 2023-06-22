import 'dart:async';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../main.dart';
import 'home.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    checkLoggedIn();
    Timer(Duration(seconds: 2), _loadScreen);
    checkLoggedIn();
  }

  void _loadScreen() async {
    // Simulate a loading process
    await Future.delayed(Duration(seconds: 2));

    // Check if the user is logged in by accessing the shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    // Navigate to the login screen or home screen based on login status
    if (isLoggedIn) {
      Get.offAll(HomePage());
    } else {
      Get.offAll(newHome());
    }
  }
  Future<void> checkLoggedIn() async {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final email = sharedPreferences.getString('email');
    if (email != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => newHome()),
      );
    }
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
