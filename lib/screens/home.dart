import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  void logout() async {
    final SharedPreferences sharedPreferences =
    await SharedPreferences.getInstance();

    // Clear the stored email from shared preferences
    await sharedPreferences.remove('email');

    // Set the flag indicating that the user has logged out
    await sharedPreferences.setBool('loggedOut', true);

    // Navigate back to the login screen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => newHome()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrangeAccent,
      appBar: AppBar(
        title: Text("Welcome"),
      ),
      body: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Welcome",
            style: TextStyle(fontSize: 24),
          ),
          ElevatedButton(
            onPressed: () {
              logout();
            },
            child: Text('Logout'),
          ),
        ],
      ),
      ),
    );
  }
}
