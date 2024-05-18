import 'package:flutter/material.dart';
import 'package:innovare_campus/components/uiHelper.dart';
import 'package:innovare_campus/controller/signup.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _regNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  final FirebaseAuthService _authService = FirebaseAuthService();

  void _togglePasswordVisibility() {
    setState(() {
      _obscureTextPassword = !_obscureTextPassword;
    });
  }

  void _toggleConfirmPasswordVisibility() {
    setState(() {
      _obscureTextConfirmPassword = !_obscureTextConfirmPassword;
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _regNoController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _signup() {
    _authService.signUp(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
      confirmPassword: _confirmPasswordController.text,
    );
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
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 20),
                    UiHelper.customText("Name"),
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your Name',
                        hintStyle: TextStyle(color: Colors.black26),
                      ),
                    ),
                    const SizedBox(height: 20),
                    UiHelper.customText("Email"),
                    TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your Email',
                        hintStyle: TextStyle(color: Colors.black26),
                      ),
                    ),
                    const SizedBox(height: 20),
                    UiHelper.customText("Registration"),
                    TextField(
                      controller: _regNoController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your Reg No. e.g SP21-BSE-000',
                        hintStyle: TextStyle(color: Colors.black26),
                      ),
                    ),
                    const SizedBox(height: 20),
                    UiHelper.customText("Password"),
                    TextField(
                      controller: _passwordController,
                      obscureText: _obscureTextPassword,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureTextPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                        hintText: 'Enter your Password',
                        hintStyle: const TextStyle(color: Colors.black26),
                      ),
                    ),
                    const SizedBox(height: 20),
                    UiHelper.customText("Confirm Password"),
                    TextField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureTextConfirmPassword,
                      decoration: InputDecoration(
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureTextConfirmPassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: _toggleConfirmPasswordVisibility,
                        ),
                        hintText: 'Confirm your Password',
                        hintStyle: const TextStyle(color: Colors.black26),
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      text: "Sign Up",
                      onPressed: _signup,
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
