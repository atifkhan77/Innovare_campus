import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:innovare_campus/Views/studyBuddy/offer_tutor_screen.dart';

import 'package:innovare_campus/Views/studyBuddy/tuttorDetailScreen.dart';
import 'package:innovare_campus/Views/userManagment/profileScreen.dart';
import 'package:innovare_campus/components/search.dart';
import 'package:innovare_campus/components/uiHelper.dart';
import 'package:innovare_campus/model/tutor.dart';
import 'package:innovare_campus/provider/tutor_provider.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RecieveTutor extends StatefulWidget {
  const RecieveTutor({super.key});

  @override
  State<RecieveTutor> createState() => _RecieveTutorState();
}

class _RecieveTutorState extends State<RecieveTutor> {
  String? _profileImageUrl;
  String? _userId;
  String _searchQuery = "";
  List<Tutor> _filteredTutors = [];

  @override
  void initState() {
    super.initState();
    _getCurrentUserId();
    Provider.of<TutorProvider>(context, listen: false).fetchTutors();
  }

  Future<void> _getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _userId = user.uid;
      });
      await _loadProfileImage();
    } else {
      debugPrint("No user is currently logged in");
    }
  }

  Future<void> _loadProfileImage() async {
    if (_userId == null) return;
    try {
      final docRef =
          FirebaseFirestore.instance.collection('users').doc(_userId);
      final doc = await docRef.get();
      if (doc.exists && doc['profile_image_url'] != null) {
        setState(() {
          _profileImageUrl = doc['profile_image_url'];
        });
      } else {
        setState(() {
          _profileImageUrl = null;
        });
      }
    } catch (e) {
      debugPrint('Failed to load profile image: $e');
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
      _filteredTutors = Provider.of<TutorProvider>(context, listen: false)
          .tutors
          .where(
              (tutor) => tutor.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

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
              child: CircleAvatar(
                backgroundImage: _profileImageUrl != null
                    ? NetworkImage(_profileImageUrl!)
                    : const AssetImage('assets/placeholder.png')
                        as ImageProvider,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Welcome',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: screenHeight * 0.03),
                const Padding(
                  padding: EdgeInsets.only(left: 95.0),
                  child: Text(
                    'StudyBuddy',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
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
                              padding: EdgeInsets.only(top: 20, left: 25),
                              child: Text(
                                'Start\nLearning',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Spacer(flex: 1),
                            Image(
                              image: AssetImage('assets/studyBuddy/girls.png'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SearchBox(
                          onChanged: _onSearchChanged,
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
                            text: 'Recieve Tutor',
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => TutorListScreen(),
                                ),
                              );
                            }),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: screenWidth * 0.37,
                        child: CustomButton(
                            text: 'Offer Tutor',
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const OfferTutorScreen(),
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                if (_searchQuery.isNotEmpty)
                  _filteredTutors.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _filteredTutors.length,
                          itemBuilder: (context, index) {
                            final tutor = _filteredTutors[index];
                            return ListTile(
                              title: Text(tutor.name),
                              subtitle: Text(tutor.subjectExpertise),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TutorDetailScreen(
                                      name: tutor.name,
                                      subjectExpertise: tutor.subjectExpertise,
                                      contactNumber: tutor.contactNumber,
                                      availability: tutor.availability,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        )
                      : const Text(
                          'No tutors available',
                          style: TextStyle(color: Colors.red),
                        ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}

class TutorListScreen extends StatelessWidget {
  const TutorListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tutors = Provider.of<TutorProvider>(context).tutors;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
        title: const Text(
          'Available Tutors',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          Container(
            height: screenHeight,
            width: screenWidth,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Splash.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Tutors list
          ListView.builder(
            itemCount: tutors.length,
            itemBuilder: (context, index) {
              final tutor = tutors[index];
              return Card(
                color: Colors.white.withOpacity(0.8),
                child: ListTile(
                  title: Text(tutor.name),
                  subtitle:
                      Text('${tutor.subjectExpertise} - ${tutor.availability}'),
                  trailing: Text(tutor.contactNumber),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TutorDetailScreen(
                          name: tutor.name,
                          subjectExpertise: tutor.subjectExpertise,
                          contactNumber: tutor.contactNumber,
                          availability: tutor.availability,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
