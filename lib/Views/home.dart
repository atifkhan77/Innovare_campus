import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innovare_campus/Views/LostandFound/lostfoundScreen.dart';
import 'package:innovare_campus/Views/Societies/clubs/societyScreen.dart';
import 'package:innovare_campus/Views/cafeteria/cafeScreen.dart';
import 'package:innovare_campus/Views/news/newsScreen.dart';
import 'package:innovare_campus/Views/print/printScreen.dart';
import 'package:innovare_campus/Views/studyBuddy/recieveTutoring.dart';
import 'package:innovare_campus/Views/userManagment/profileScreen.dart';
import 'package:innovare_campus/components/uiHelper.dart'; // Make sure this is correct

class HomeScreen extends StatefulWidget {
  final String userId;

  HomeScreen({super.key, required this.userId});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? _profileImageUrl;
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    _loadUserName();
  }

  Future<void> _loadProfileImage() async {
    try {
      final ref =
          FirebaseStorage.instance.ref().child('path/to/profile_picture.png');
      final url = await ref.getDownloadURL();
      setState(() {
        _profileImageUrl = url;
      });
    } catch (e) {
      // Handle errors
      print('Failed to load profile image: $e');
    }
  }

  Future<void> _loadUserName() async {
    try {
      final docRef =
          FirebaseFirestore.instance.collection('users').doc(widget.userId);
      final doc = await docRef.get();
      if (doc.exists) {
        setState(() {
          _userName = doc['name'] ?? 'User';
        });
      } else {
        setState(() {
          _userName = 'User';
        });
      }
    } catch (e) {
      // Handle errors
      print('Failed to load user name: $e');
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
            Text(
              _userName != null ? 'Welcome back, $_userName' : 'Welcome back',
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Splash.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
                height: screenHeight *
                    0.05), // Add some spacing between AppBar and image
            Center(
              child: Image.asset(
                'assets/homeScreen/homeScreen.png', // Replace with your image asset
                width: screenWidth * 0.99,
                height: screenHeight * 0.30,
              ),
            ),
            const SizedBox(
                height: 16), // Add some spacing between the image and the grid
            Expanded(
              child: GridView.count(
                crossAxisCount: 3, // Three cards per row
                children: [
                  CardComponent(
                    title: 'Study Buddy',
                    assetPath: 'assets/homeScreen/Man.png',
                    onTap: () {
                      // ignore: prefer_const_constructors
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RecieveTutor()));
                    },
                  ),
                  CardComponent(
                    title: 'Cafe',
                    assetPath: 'assets/homeScreen/cafe.jpeg',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CafeScreen()));
                    },
                  ),
                  CardComponent(
                    title: 'Print',
                    assetPath: 'assets/homeScreen/print.jpeg',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PrintScreen()));
                    },
                  ),
                  CardComponent(
                    title: 'Lost & Found',
                    assetPath: 'assets/homeScreen/lostfound.jpeg',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LostFoundScreen()));
                    },
                  ),
                  CardComponent(
                    title: 'Society',
                    assetPath: 'assets/homeScreen/society.jpeg',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SocietiesScreen()));
                    },
                  ),
                  CardComponent(
                    title: 'Announcements',
                    assetPath: 'assets/homeScreen/announc.jpeg',
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => NewsScreen()));
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
