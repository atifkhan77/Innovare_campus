import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';

class homescreen extends StatefulWidget {
  @override
  _homescreenState createState() => _homescreenState();
}

class _homescreenState extends State<homescreen> {
  String? _profileImageUrl;

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome back, Tanzeel'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundImage: _profileImageUrl != null
                  ? NetworkImage(_profileImageUrl!)
                  : const AssetImage('assets/placeholder.png')
                      as ImageProvider, // Use a placeholder image
            ),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/splash.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: GridView.count(
          crossAxisCount: 3, // Three cards per row
          children: const [
            Card(
              child: Center(
                child: Text('Chats'),
              ),
            ),
            Card(
              child: Center(
                child: Text('Cafe'),
              ),
            ),
            Card(
              child: Center(
                child: Text('Print'),
              ),
            ),
            Card(
              child: Center(
                child: Text('News'),
              ),
            ),
            Card(
              child: Center(
                child: Text('Lost&Found'),
              ),
            ),
            Card(
              child: Center(
                child: Text('Society'),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Add functionality for search icon here
              },
            ),
            IconButton(
              icon: const Icon(Icons.notifications),
              onPressed: () {
                // Add functionality for notification icon here
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Add functionality for settings icon here
              },
            ),
          ],
        ),
      ),
    );
  }
}
