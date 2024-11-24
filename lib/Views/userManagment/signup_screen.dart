import 'package:flutter/material.dart';
import 'package:innovare_campus/components/reg_no.dart';
import 'package:innovare_campus/components/uiHelper.dart';
import 'package:innovare_campus/controller/firebase_services.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  bool _obscureTextPassword = true;
  bool _obscureTextConfirmPassword = true;

  final _formKey = GlobalKey<FormState>();

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
    if (_formKey.currentState?.validate() ?? false) {
      _authService.signUp(
        context: context,
        email: _emailController.text,
        password: _passwordController.text,
        confirmPassword: _confirmPasswordController.text,
        name: _nameController.text,
        regNo: _regNoController.text,
      );
    }
  }

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
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      "Welcome to Innovare Campus",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Create your account to get started!",
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
          // Right Column: Signup Form
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
                          "Register",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
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
                        UiHelper.customText("Registration Number"),
                        RegistrationNumberField(controller: _regNoController),
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
            ),
          ),
        ],
      ),
    );
  }
}
