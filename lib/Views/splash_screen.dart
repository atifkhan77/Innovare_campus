import 'dart:async';
import 'package:flutter/material.dart';
import 'package:innovare_campus/Views/userManagment/login1_screen.dart';
// Import your login screen

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Set a Timer for 5 seconds
    Timer(Duration(seconds: 3), () {
      // Navigate to the login screen
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Splash.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            top: 50, // Adjust this value to position the logo vertically
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/logo.png',
                width: 200,
                height: 400,
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/text.png',
                width: 200,
                height: 600,
              ),
            ),
          ),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/text2.png',
                width: 200,
                height: 670,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
