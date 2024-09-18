import 'dart:async';
import 'package:flutter/material.dart';
import 'package:innovare_campus/Views/userManagment/login1_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the AnimationController
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3), // Adjust the duration if needed
    ); // Continuously repeat the animation

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    // Set a Timer for 3 seconds
    Timer(Duration(seconds: 4), () {
      // Navigate to the login screen
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
              child: RotationTransition(
                turns: _rotationAnimation,
                child: Image.asset(
                  'assets/logo.png',
                  width: 200,
                  height: 200, // Adjust height to fit the logo appropriately
                ),
              ),
            ),
          ),
          Positioned(
            top: 250, // Adjust this value to position the text vertically
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/text.png',
                width: 200,
                height: 100, // Adjust height to fit the text appropriately
              ),
            ),
          ),
          Positioned(
            top: 360, // Adjust this value to position the text vertically
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/text2.png',
                width: 200,
                height: 100, // Adjust height to fit the text appropriately
              ),
            ),
          ),
        ],
      ),
    );
  }
}
