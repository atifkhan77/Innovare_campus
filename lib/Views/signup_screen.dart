import 'package:flutter/material.dart';
import 'package:innovare_campus/components/uiHelper.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Splash.png"), // Use the same image as the splash screen
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            left: 100,
            top: 50, // Adjust the top position to move the image to the top
            child: Image.asset(
              'assets/Register.png',
              width: 150, // Adjust the width as needed
              height: 150, // Adjust the height as needed
            ),
          ),
          Positioned(
            left: 20,
            right: 20,
            top: 230, // Adjust the top position to position the white box below the image
            child: Container(
              color: Colors.white,
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Registration Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                   SizedBox(height: 20),
                   CustomButton(text: "Sign Up", onPressed: (){})
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
