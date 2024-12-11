import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:innovare_campus/Views/studyBuddy/RequestsScreen.dart';
import 'package:innovare_campus/Views/userManagment/profileScreen.dart';
import 'package:innovare_campus/components/uiHelper.dart';
import 'package:innovare_campus/model/tutor.dart';
import 'package:innovare_campus/provider/tutor_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OfferTutorScreen extends StatefulWidget {
  const OfferTutorScreen({super.key});

  @override
  _OfferTutorScreenState createState() => _OfferTutorScreenState();
}

class _OfferTutorScreenState extends State<OfferTutorScreen> {
  String? _profileImageUrl;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController contactController = TextEditingController();
  String availability = 'Morning';

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
  }

  Future<void> _loadProfileImage() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final docRef =
            FirebaseFirestore.instance.collection('users').doc(user.uid);
        final doc = await docRef.get();
        if (doc.exists && doc['profile_image_url'] != null) {
          setState(() {
            _profileImageUrl = doc['profile_image_url'];
          });
        }
      } catch (e) {
        debugPrint('Failed to load profile image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfileScreen()),
                );
              },
              child: CircleAvatar(
                backgroundImage: _profileImageUrl != null
                    ? NetworkImage(_profileImageUrl!)
                    : const AssetImage('assets/placeholder.png')
                        as ImageProvider,
              ),
            ),
            const Text(
              'Welcome ',
              style: TextStyle(color: Colors.white70),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const RequestsScreen()),
                );
              },
              child: const Icon(Icons.school, color: Colors.white),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: screenHeight,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Splash.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'StudyBuddy',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: subjectController,
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(color: Colors.white),
                      labelStyle: TextStyle(color: Colors.white),
                      labelText: 'Subject Expertise',
                      hintText: 'Enter your subject expertise',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Availability',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ChoiceChip(
                        label: const Text('Morning'),
                        selected: availability == 'Morning',
                        onSelected: (selected) {
                          setState(() {
                            availability = 'Morning';
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Afternoon'),
                        selected: availability == 'Afternoon',
                        onSelected: (selected) {
                          setState(() {
                            availability = 'Afternoon';
                          });
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Evening'),
                        selected: availability == 'Evening',
                        onSelected: (selected) {
                          setState(() {
                            availability = 'Evening';
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(color: Colors.white),
                      labelStyle: TextStyle(color: Colors.white),
                      labelText: 'Name',
                      hintText: 'Enter your name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: contactController,
                    decoration: const InputDecoration(
                      hintStyle: TextStyle(color: Colors.white),
                      labelStyle: TextStyle(color: Colors.white),
                      labelText: 'Contact Number',
                      hintText: 'Enter your number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(0, 0, 70, 1),
                          minimumSize:
                              Size(screenWidth * 0.6, screenHeight * 0.06)),
                      onPressed: () {
                        final tutor = Tutor(
                          name: nameController.text,
                          subjectExpertise: subjectController.text,
                          availability: availability,
                          contactNumber: contactController.text,
                        );
                        final tutorProvider =
                            Provider.of<TutorProvider>(context, listen: false);
                        tutorProvider.addTutor(tutor);
                        tutorProvider.setTutor(tutor.name, tutor.contactNumber);

                        nameController.clear();
                        subjectController.clear();
                        contactController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Tutor submitted successfully')),
                        );
                      },
                      child: const Text(
                        'Submit Tutor',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
