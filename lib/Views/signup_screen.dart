import 'package:flutter/material.dart';
import 'package:innovare_campus/components/uiHelper.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _obscureText = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    "assets/Splash.png"), // Use the same image as the splash screen
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            left: screenWidth * .35,
            top: screenHeight * .20,
            child: const Text(
              "Register",
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: screenHeight * .30),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.white,
              ),
              padding: EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    UiHelper.customText("Name"),
                    const TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter your Name',
                        hintStyle: TextStyle(color: Colors.black26),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    UiHelper.customText("Email"),
                    const TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter your Email',
                        hintStyle: TextStyle(color: Colors.black26),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    UiHelper.customText("Registration"),
                    const TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter your Reg No. e.g SP21-BSE-000',
                        hintStyle: TextStyle(color: Colors.black26),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    UiHelper.customText("Password"),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                        hintText: 'Enter your Password',
                        hintStyle: TextStyle(color: Colors.black26),
                      ),
                    ),
                    SizedBox(height: 20),
                    UiHelper.customText("Confirm Password"),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureText,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                        hintText: 'Confirm your Password',
                        hintStyle: const TextStyle(color: Colors.black26),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: "Sign Up",
                      onPressed: () {
                        if (_passwordController.text ==
                            _confirmPasswordController.text) {
                          // Passwords match, proceed with signup
                          // Implement your signup logic here
                          // For example, you can navigate to the next screen
                        } else {
                          // Passwords do not match, show an error message
                          // You can display a snackbar or any other UI element to inform the user
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Passwords do not match.'),
                            ),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
