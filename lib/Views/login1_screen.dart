import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration:const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/Splash.png"), // Use the same image as the splash screen
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
              left: screenWidth * .35,
              top: screenHeight *
                  .20, // Adjust the top position to move the image to the top
              child: const Text(
                "Login",
                style: TextStyle(
                    color: Colors.white, fontSize: 36, fontFamily: 'Quicksand'),
              )),
          Padding(
            padding: EdgeInsets.only(top: screenHeight * .30),
            child: Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Colors.white),
                padding: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Email",
                        style: TextStyle(
                            color: Color.fromRGBO(0, 0, 70, 1),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        decoration: InputDecoration(
                          hintText: ' Enter your Email',
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Password",
                        style: TextStyle(
                            
                            color: Color.fromRGBO(0, 0, 70, 1),
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Enter your Password',
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
                          padding: EdgeInsets.symmetric(
                              vertical: 12), // Adjust padding
                          backgroundColor: Color.fromARGB(255, 119, 37,
                              243), // Change button color to purple
                        ),
                        onPressed: () {
                          // Implement login functionality
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
