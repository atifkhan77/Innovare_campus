import 'package:flutter/material.dart';
import 'package:innovare_campus/Views/forgotPassword.dart';
import 'package:innovare_campus/Views/signup_screen.dart';
import 'package:innovare_campus/components/uiHelper.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;

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
                image: AssetImage("assets/Splash.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Positioned(
            left: screenWidth * .35,
            top: screenHeight * .20,
            child: const Text(
              "Login",
              style: TextStyle(
                  color: Colors.white, fontSize: 36),
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
                    UiHelper.customText("Email"),
                    const TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter your Email',
                        hintStyle: TextStyle(color:Colors.black26),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    UiHelper.customText("Password"),
                    TextField(
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
                        hintStyle:const TextStyle(color:Colors.black26),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Checkbox(value: false, onChanged: null),
                        Text('Stay signed in'),
                        Spacer(),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(builder: (context)=>ForgotPassword()));
                          },
                          child: Text('Forgot password?'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    CustomButton(text: "Login", onPressed: (){}),
                    Padding(
                      padding:  EdgeInsets.only(left: screenWidth*0.5),
                      child: TextButton(onPressed: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SignupScreen()));
                      }, child: const Text(
                        "Not Registered?"
                      )),
                    )
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
