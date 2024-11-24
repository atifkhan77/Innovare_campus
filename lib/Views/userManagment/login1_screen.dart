import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:innovare_campus/Views/userManagment/forgotPassword.dart';
import 'package:innovare_campus/Views/home.dart';
import 'package:innovare_campus/Views/userManagment/signup_screen.dart';
import 'package:innovare_campus/components/uiHelper.dart';
import 'package:innovare_campus/controller/firebase_services.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;
  bool _staySignedIn = false;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseAuthService _authService = FirebaseAuthService();

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _login() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );

      User? user = userCredential.user;
      if (user != null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen(userId: user.uid)),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to login: $e')),
      );
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left column: Welcome text and additional message
          Expanded(
            flex: 1,
            child: Container(
              color: const Color.fromRGBO(49, 42, 119, 1),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Text(
                      "Welcome to Innovare Campus",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Your gateway to excellence in education.\nPlease log in to continue.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white60,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Right column: Login form
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "Login",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        UiHelper.customText("Email"),
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your Email',
                            hintStyle: TextStyle(color: Colors.black26),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        UiHelper.customText("Password"),
                        TextFormField(
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
                            hintStyle: const TextStyle(color: Colors.black26),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Checkbox(
                              value: _staySignedIn,
                              onChanged: (bool? value) {
                                setState(() {
                                  _staySignedIn = value!;
                                });
                              },
                            ),
                            const Text('Stay signed in'),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => ForgotPassword()),
                                );
                              },
                              child: const Text('Forgot password?'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        CustomButton(
                          text: "Login",
                          onPressed: _login,
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => SignupScreen()),
                            );
                          },
                          child: const Text("Not Registered? Sign up here!"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
