import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:innovare_campus/Views/userManagment/login1_screen.dart';
import 'package:innovare_campus/components/uiHelper.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({Key? key}) : super(key: key);

  final TextEditingController _emailController = TextEditingController();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left Column: Welcome message
          Expanded(
            flex: 1,
            child: Container(
              color: const Color.fromRGBO(49, 42, 119, 1),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Forgot Your Password?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Don’t worry! We’ll help you recover it.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Right Column: Form
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Reset Your Password',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Enter your registered email address to receive a password reset link.',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      UiHelper.customText("Your Email"),
                      TextField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your Email',
                          hintStyle: TextStyle(color: Colors.black38),
                        ),
                      ),
                      const SizedBox(height: 20),
                      CustomButton(
                        text: "Send Reset Link",
                        onPressed: () {
                          auth
                              .sendPasswordResetEmail(
                                  email: _emailController.text.toString())
                              .then((_) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Password reset email sent.'),
                              ),
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => LoginScreen()),
                            );
                          }).catchError((error) {
                            debugPrint(error.toString());
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Failed to send password reset email.'),
                              ),
                            );
                          });
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Haven’t got the email yet?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black45,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Resend email logic here
                            },
                            child: const Text(
                              'Resend email',
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
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
