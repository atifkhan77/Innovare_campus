import 'dart:async';
import 'package:flutter/material.dart';
import 'package:innovare_campus/Views/userManagment/login1_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

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

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));

    Timer(const Duration(seconds: 4), () {
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
            top: 50,
            left: 0,
            right: 0,
            child: Center(
              child: RotationTransition(
                turns: _rotationAnimation,
                child: Image.asset(
                  'assets/logo.png',
                  width: 200,
                  height: 200,
                ),
              ),
            ),
          ),
          Positioned(
            top: 250,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/text.png',
                width: 200,
                height: 100,
              ),
            ),
          ),
          Positioned(
            top: 360,
            left: 0,
            right: 0,
            child: Center(
              child: Image.asset(
                'assets/text2.png',
                width: 200,
                height: 100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
