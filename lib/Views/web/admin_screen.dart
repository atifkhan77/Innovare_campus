import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:innovare_campus/Views/web/cafeadmin_dashbaord/cafeAdminDashboardScreen.dart';
import 'package:innovare_campus/components/uiHelper.dart';
import 'admin_dashboard/admin_dashboard.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  bool _obscureText = true;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FirebaseAuth _auth = FirebaseAuth.instance;

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
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid admin credentials')),
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
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Splash.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            left: screenWidth * .35,
            top: screenHeight * .20,
            child: const Text(
              "Admin Login",
              style: TextStyle(color: Colors.white, fontSize: 36),
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      UiHelper.customText("Username"),
                      TextFormField(
                        controller: _usernameController,
                        decoration: const InputDecoration(
                          hintText: 'Enter your Username',
                          hintStyle: TextStyle(color: Colors.black26),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your Username';
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
                      const SizedBox(height: 20),
                      SizedBox(
                        width: screenWidth * 0.5,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            backgroundColor:
                                const Color.fromRGBO(49, 42, 119, 1),
                          ),
                          onPressed: _loginAdmin,
                          child: Text(
                            "Login",
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
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
