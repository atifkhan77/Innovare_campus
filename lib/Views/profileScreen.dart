import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

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
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
  }

  Future<void> _loadUserProfile() async {
    try {
      // Load user data from Firestore
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc('user_id')
          .get();
      setState(() {
        _userName = doc['name'];
        _userEmail = doc['email'];
        _contactNumber = doc['contact_number'];
        _address = doc['address'];
        _userNameController.text = _userName!;
        _userEmailController.text = _userEmail!;
        _contactNumberController.text = _contactNumber!;
        _addressController.text = _address!;
      });

      // Load profile image from Firebase Storage
      final ref = FirebaseStorage.instance
          .ref()
          .child('users/user_id/profile_picture.png');
      final url = await ref.getDownloadURL();
      setState(() {
        _profileImageUrl = url;
      });
    } catch (e) {
      // Handle errors
      print('Failed to load user profile: $e');
    }
  }

  Future<void> _saveUserProfile() async {
    try {
      String? profileImageUrl;

      // If a new image is selected, upload it to Firebase Storage
      if (_imageFile != null) {
        final ref = FirebaseStorage.instance
            .ref()
            .child('users/user_id/profile_picture.png');
        await ref.putFile(_imageFile!);
        profileImageUrl = await ref.getDownloadURL();
      }

      // Update user data in Firestore
      await FirebaseFirestore.instance
          .collection('users')
          .doc('user_id')
          .update({
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
      // Handle errors
      print('Failed to update user profile: $e');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveUserProfile,
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                        : const AssetImage('assets/placeholder.png')
                            as ImageProvider),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _userNameController,
              decoration: const InputDecoration(labelText: 'Username'),
              onChanged: (value) => setState(() => _userName = value),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _userEmailController,
              decoration: const InputDecoration(labelText: 'Email'),
              onChanged: (value) => setState(() => _userEmail = value),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contactNumberController,
              decoration: const InputDecoration(labelText: 'Contact Number'),
              onChanged: (value) => setState(() => _contactNumber = value),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Address'),
              onChanged: (value) => setState(() => _address = value),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveUserProfile,
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
