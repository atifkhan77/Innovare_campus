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
    super.key,
    required this.name,
    required this.subjectExpertise,
    required this.contactNumber,
    required this.availability,
  });

  Future<String> _getStudentName() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final docSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (docSnapshot.exists) {
        return docSnapshot.data()?['name'] ?? 'Unknown User';
      }
    }
    return 'Unknown User';
  }

  Future<String> _getTutorImageUrl() async {
    final tutorQuery = await FirebaseFirestore.instance
        .collection('tutors')
        .where('name', isEqualTo: name)
        .get();

    if (tutorQuery.docs.isNotEmpty) {
      final tutorDoc = tutorQuery.docs.first;
      final userId = tutorDoc.id;

      final userDocSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDocSnapshot.exists) {
        return userDocSnapshot.data()?['profile_image_url'] ??
            'assets/placeholder.png';
      }
    }
    return 'assets/placeholder.png';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
        title: const Text('Tutor Profile'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Splash.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder<String>(
                    future: _getStudentName(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final String studentName =
                          snapshot.data ?? 'Unknown User';

                      return FutureBuilder<String>(
                        future: _getTutorImageUrl(),
                        builder: (context, imageSnapshot) {
                          if (imageSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }

                          final String tutorImageUrl =
                              imageSnapshot.data ?? 'assets/placeholder.png';

                          return Container(
                            margin: const EdgeInsets.all(16),
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
                                ],
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    backgroundImage:
                                        NetworkImage(tutorImageUrl),
                                    radius: 50,
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    name,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    subjectExpertise,
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 18,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  const Divider(color: Colors.white70),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Contact',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        contactNumber,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Availability',
                                        style: TextStyle(
                                          color: Colors.white70,
                                          fontSize: 18,
                                        ),
                                      ),
                                      Text(
                                        availability,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  ElevatedButton(
                                    onPressed: () async {
                                      final studentName =
                                          await _getStudentName();

                                      final request = Request(
                                        tutorName: name,
                                        studentName: studentName,
                                        message:
                                            'Requesting for tutoring in $subjectExpertise',
                                        id: '',
                                      );

                                      await Provider.of<TutorProvider>(context,
                                              listen: false)
                                          .sendRequest(request);

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Request sent successfully')),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          const Color.fromRGBO(49, 42, 119, 1),
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16),
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
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
