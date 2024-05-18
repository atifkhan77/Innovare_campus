import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  User? _user;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    User? user = _auth.currentUser;
    setState(() {
      _user = user;
    });

    if (user != null) {
      DocumentSnapshot userData = await _firestore.collection('users').doc(user.uid).get();
      Map<String, dynamic> userDataMap = userData.data() as Map<String, dynamic>;

      _usernameController.text = userDataMap['username'];
      _emailController.text = user.email ?? '';
      _contactNumberController.text = userDataMap['contactNumber'];
      _addressController.text = userDataMap['address'];
    }

    // Check if profile image exists in Firebase Storage
    Reference ref = _storage.ref().child('profile_images/${user?.uid}.jpg');
    try {
      await ref.getDownloadURL();
    } catch (e) {
      // Profile image doesn't exist, set default image
      setState(() {
        _imageFile = null;
      });
    }
  }

  Future<void> _updateUserData() async {
    if (_user != null) {
      await _firestore.collection('users').doc(_user!.uid).update({
        'username': _usernameController.text,
        'contactNumber': _contactNumberController.text,
        'address': _addressController.text,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Profile updated successfully'),
      ));
    }
  }

  Future<void> _uploadProfileImage() async {
    if (_imageFile != null && _user != null) {
      Reference ref = _storage.ref().child('profile_images/${_user!.uid}.jpg');
      UploadTask uploadTask = ref.putFile(_imageFile!);
      TaskSnapshot taskSnapshot = await uploadTask;
      if (taskSnapshot.state == TaskState.success) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Profile image uploaded successfully'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to upload profile image'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              _updateUserData();
              _uploadProfileImage();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: _imageFile != null
                  ? CircleAvatar(
                      radius: 50,
                      backgroundImage: FileImage(_imageFile!),
                    )
                  : CircularProgressIndicator(), // Show loading indicator if image is being fetched
            ),
            SizedBox(height: 20),
           ElevatedButton(
  onPressed: () async {
    // Open image picker to select profile image
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  },
  child: Text('Change Profile Picture'),
),
            SizedBox(height: 20),
            Text(
              'Username',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                hintText: 'Enter username',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Email',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                hintText: 'Email',
              ),
              readOnly: true,
            ),
            SizedBox(height: 20),
            Text(
              'Contact Number',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _contactNumberController,
              decoration: InputDecoration(
                hintText: 'Enter contact number',
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Address',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                hintText: 'Enter address',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
