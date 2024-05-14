import 'package:flutter/material.dart';

class Login1Screen extends StatelessWidget {
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
              'assets/Login.png',
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
                      labelText: 'Email',
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
                  Row(
                    children: [
                      Checkbox(value: false, onChanged: null),
                      Text('Stay signed in'),
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          // Implement forgot password functionality
                        },
                        child: Text('Forgot password?'),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                     style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(vertical: 12), // Adjust padding
                          backgroundColor: Color.fromARGB(255, 119, 37, 243), // Change button color to purple
                        ),
                    onPressed: () {
                      // Implement login functionality
                    },
                    child: Text('Login',
                    style: TextStyle(color: Colors.white),
                  ),),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
