import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:innovare_campus/Views/web/cafeadmin_dashbaord/cafeAdminDashboardScreen.dart';
import 'package:innovare_campus/components/uiHelper.dart';
import 'admin_dashboard/admin_dashboard.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen>
    with SingleTickerProviderStateMixin {
  bool _obscureText = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  late AnimationController _controller;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<void> _loginAdmin() async {
    if (_formKey.currentState!.validate()) {
      String email = _usernameController.text;
      String password = _passwordController.text;

      try {
        UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        if (email == 'admin@example.com') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminDashboardScreen()),
          );
        } else if (email == 'cafeadmin@example.com') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CafeAdminDashboardScreen()),
          );
        } else if (email == 'societyadmin@example.com') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AdminDashboardScreen()),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Invalid admin credentials')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login failed: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Row(
        children: [
          // Left Column: Image/Branding
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/Splash.png"),
                  fit: BoxFit.cover,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/logo.png',
                    width: screenWidth * 0.2,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Admin Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Right Column: Form
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: SlideTransition(
                position: _slideAnimation,
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        UiHelper.customText("Admin Id"),
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            hintText: 'Enter your Admin Id',
                            hintStyle: TextStyle(color: Colors.black26),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your admin Id';
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
                        const SizedBox(height: 40),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor:
                                const Color.fromRGBO(49, 42, 119, 1),
                          ),
                          onPressed: _loginAdmin,
                          child: const Text(
                            "Login",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
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
