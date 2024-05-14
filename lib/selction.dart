import 'package:flutter/material.dart';
import 'login1_screen.dart'; // Import your login1 screen
import 'signup_screen.dart'; // Import your signup screen

class LoginScreen extends StatelessWidget {
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
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Add your logo here
                Image.asset(
                  'assets/logo.png',
                  width: 150, // Adjust the width as needed
                  height: 150, // Adjust the height as needed
                ),
                SizedBox(height: 40), // Adjust spacing as needed
                // Add login and signup buttons in a row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 120, // Adjust the width of the button
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to login1 screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login1Screen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12), // Adjust padding
                          backgroundColor: Color.fromARGB(255, 119, 37, 243), // Change button color to purple
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white), // Change text color to white
                        ),
                      ),
                    ),
                    SizedBox(width: 20), // Adjust spacing between buttons
                    Container(
                      width: 120, // Adjust the width of the button
                      child: ElevatedButton(
                        onPressed: () {
                          // Navigate to signup screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignupScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12), // Adjust padding
                          backgroundColor: Color.fromARGB(255, 119, 37, 243), // Change button color to purple
                        ),
                        child: Text(
                          'Sign Up',
                          style: TextStyle(color: Colors.white), // Change text color to white
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
