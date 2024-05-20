import 'package:flutter/material.dart';
import 'package:innovare_campus/Views/userManagment/profileScreen.dart';
import 'package:innovare_campus/components/search.dart';
import 'package:innovare_campus/components/uiHelper.dart';

class RecieveTutor extends StatefulWidget {
  const RecieveTutor({Key? key});

  @override
  State<RecieveTutor> createState() => _RecieveTutorState();
}

class _RecieveTutorState extends State<RecieveTutor> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
              child: const CircleAvatar(
                backgroundImage: AssetImage('assets/placeholder.png'),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Welcome back',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: screenHeight * .85,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/Splash.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: screenHeight * 0.03),
                    const Text(
                      'StudyBuddy',
                      style: TextStyle(
                          color: Colors.white70,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Center(
                      child: Container(
                        width: screenWidth * 0.95,
                        height: screenHeight * 0.33,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(25),
                          border: Border.all(color: Colors.black, width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                          gradient: const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.fromRGBO(169, 203, 255, 1),
                                Color.fromRGBO(98, 120, 153, 1)
                              ]),
                        ),
                        child: Column(
                          children: [
                            const Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 20, left: 10),
                                  child: Text(
                                    'Start\nLearning',
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Spacer(flex: 1),
                                Image(
                                  image:
                                      AssetImage('assets/studyBuddy/girls.png'),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SearchBox(
                              onChanged: (value) {
                                // Handle search functionality
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.2),
                    Padding(
                      padding: EdgeInsets.all(screenWidth * 0.1),
                      child: Row(
                        children: [
                          SizedBox(
                            width: screenWidth * 0.37,
                            child: CustomButton(
                                text: 'Recieve Tutor', onPressed: () {}),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: screenWidth * 0.37,
                            child: CustomButton(
                                text: 'Recieve Tutor', onPressed: () {}),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
