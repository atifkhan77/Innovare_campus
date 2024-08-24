import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:innovare_campus/components/uiHelper.dart';
import 'package:innovare_campus/model/request.dart';
import 'package:innovare_campus/provider/tutor_provider.dart';
import 'package:provider/provider.dart';

class TutorDetailScreen extends StatelessWidget {
  final String name;
  final String subjectExpertise;
  final String contactNumber;
  final String availability;

  const TutorDetailScreen({
    Key? key,
    required this.name,
    required this.subjectExpertise,
    required this.contactNumber,
    required this.availability,
  }) : super(key: key);

  Future<String> _getStudentName() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Fetch the name from Firestore using the user's UID
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (docSnapshot.exists) {
        return docSnapshot.data()?['name'] ?? 'Unknown User';
      }
    }
    return 'Unknown User'; // Default if no user is logged in
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
        title: const Text('Tutor Profile'),
      ),
      body: FutureBuilder<String>(
        future: _getStudentName(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final String studentName = snapshot.data ?? 'Unknown User';

          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    height: screenHeight * .85,
                    decoration: const BoxDecoration(
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
                            height: screenHeight * 0.5,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const CircleAvatar(
                                        backgroundImage: AssetImage('assets/placeholder.png'),
                                        radius: 50,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        name,
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        subjectExpertise,
                                        style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 18),
                                      ),
                                      const SizedBox(height: 16),
                                      const Divider(color: Colors.white70),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Contact',
                                            style: TextStyle(color: Colors.white70, fontSize: 18),
                                          ),
                                          Text(
                                            contactNumber,
                                            style: const TextStyle(color: Colors.white70, fontSize: 18),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Text(
                                            'Availability',
                                            style: TextStyle(color: Colors.white70, fontSize: 18),
                                          ),
                                          Text(
                                            availability,
                                            style: const TextStyle(color: Colors.white70, fontSize: 18),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      final studentName = await _getStudentName();

                                      final request = Request(
                                        tutorName: name,
                                        studentName: studentName,
                                        message: 'Requesting for tutoring in $subjectExpertise', id: '',
                                      );

                                      await Provider.of<TutorProvider>(context, listen: false).sendRequest(request);

                                      // Show a confirmation message
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Request sent successfully')),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        'Send Request',
                                        style: TextStyle(fontSize: 18),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
