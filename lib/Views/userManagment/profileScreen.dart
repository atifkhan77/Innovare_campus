import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:innovare_campus/Views/userManagment/login1_screen.dart';
import 'package:innovare_campus/components/uiHelper.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _profileImageUrl;
  String? _userName;
  String? _userEmail;
  String? _contactNumber;
  String? _address;

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _userEmailController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      // Get current user ID
      String userId = _auth.currentUser!.uid;

      // Load user data from Firestore
      final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      if (doc.exists) {
        setState(() {
          _userName = doc['name'];
          _userEmail = doc['email'];
          _contactNumber = doc['contact_number'];
          _address = doc['address'];
          _userNameController.text = _userName ?? '';
          _userEmailController.text = _userEmail ?? '';
          _contactNumberController.text = _contactNumber ?? '';
          _addressController.text = _address ?? '';
        });

        // Load profile image from Firebase Storage
        try {
          final ref = FirebaseStorage.instance.ref().child('users/$userId/profile_picture.png');
          final url = await ref.getDownloadURL();
          setState(() {
            _profileImageUrl = url;
          });
        } catch (e) {
          print('Failed to load profile image: $e');
        }
      } else {
        print('User document does not exist');
      }
    } catch (e) {
      print('Failed to load user profile: $e');
    }
  }

  Future<void> _saveUserProfile() async {
    try {
      String? profileImageUrl;

      // Get current user ID
      String userId = _auth.currentUser!.uid;

      // If a new image is selected, upload it to Firebase Storage
      if (_imageFile != null) {
        try {
          final ref = FirebaseStorage.instance.ref().child('users/$userId/profile_picture.png');
          await ref.putFile(_imageFile!);
          profileImageUrl = await ref.getDownloadURL();
          setState(() {
            _profileImageUrl = profileImageUrl;
          });
        } catch (e) {
          print('Failed to upload profile image: $e');
        }
      }

      // Update user data in Firestore
      await FirebaseFirestore.instance.collection('users').doc(userId).update({
        'name': _userNameController.text,
        'email': _userEmailController.text,
        'contact_number': _contactNumberController.text,
        'address': _addressController.text,
        'profile_image_url': profileImageUrl ?? _profileImageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully'),
        ),
      );
    } catch (e) {
      print('Failed to update user profile: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update profile: $e'),
        ),
      );
    }
  }

  Future<void> _getImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

   Future<void> _logout() async {
    try {
      await _auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()), // Navigate to login screen
      );}catch (e) {
      print('Failed to log out: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to log out: $e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(49, 42, 119, 1),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white70),
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/Splash.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: _getImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null
                        ? FileImage(_imageFile!)
                        : (_profileImageUrl != null
                            ? NetworkImage(_profileImageUrl!)
                            : const AssetImage('assets/placeholder.png') as ImageProvider),
                  ),
                ),
                Center(
                  child: Text(
                    _userName ?? '',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white70,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _userNameController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    labelStyle: TextStyle(color: Colors.white70, fontSize: 18),
                    fillColor: Colors.white70,
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.white70,
                    ),
                    suffixIcon: Icon(
                      Icons.edit,
                      color: Colors.white70,
                    ),
                  ),
                  onChanged: (value) => setState(() => _userName = value),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _userEmailController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.white70, fontSize: 18),
                    fillColor: Colors.white70,
                    prefixIcon: Icon(
                      Icons.email,
                      color: Colors.white70,
                    ),
                    suffixIcon: Icon(
                      Icons.edit,
                      color: Colors.white70,
                    ),
                  ),
                  onChanged: (value) => setState(() => _userEmail = value),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contactNumberController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Contact Number',
                    labelStyle: TextStyle(color: Colors.white70, fontSize: 18),
                    fillColor: Colors.white70,
                    prefixIcon: Icon(
                      Icons.phone,
                      color: Colors.white70,
                    ),
                    suffixIcon: Icon(
                      Icons.edit,
                      color: Colors.white70,
                    ),
                  ),
                  onChanged: (value) => setState(() => _contactNumber = value),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _addressController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    labelStyle: TextStyle(color: Colors.white70, fontSize: 18),
                    fillColor: Colors.white70,
                    prefixIcon: Icon(
                      Icons.home,
                      color: Colors.white70,
                    ),
                    suffixIcon: Icon(
                      Icons.edit,
                      color: Colors.white70,
                    ),
                  ),
                  onChanged: (value) => setState(() => _address = value),
                ),
                const SizedBox(height: 25),
                CustomButton(
                  onPressed: _saveUserProfile,
                  text: 'Save Changes',
                ),
                const SizedBox(height: 16),
                CustomButton(
                  onPressed: _logout,
                  text: 'Log Out',
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: const NavBar(),
    );
  }
}
