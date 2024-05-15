import 'package:flutter/material.dart';
import 'package:innovare_campus/components/uiHelper.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

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
            left: screenWidth * .12,
            top: screenHeight * .20,
            child: const Text(
              "Forgot password",
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
                    // const SizedBox(
                    //   height: 10,
                    // ),
                    Text('Please enter your email to reset the password',style: TextStyle(color: Colors.black26,fontSize: 15,fontWeight: FontWeight.w700),),
                    SizedBox(height: 10,),
                    UiHelper.customText("Your email"),
                    const TextField(
                      decoration: InputDecoration(
                        hintText: 'Enter your Email',
                        hintStyle: TextStyle(color:Colors.black26),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Text('We will send a password reset link to this email address',style: TextStyle(color: Colors.black26,fontSize: 12),),
                    
                    const SizedBox(height: 10),
                    
                    const SizedBox(height: 20),
                    CustomButton(text: "Reset Password", onPressed: (){}),
                    Padding(
                      padding: const EdgeInsets.only(top: 20,left: 20),
                      child: Row(children: [
                        const Text('Haven’t got the email yet?',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black26
                        ),),
                        TextButton(onPressed: (){}, child:const Text('Resend email',style: TextStyle(color: Colors.blue,decoration: TextDecoration.underline),)),

                      ],),

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