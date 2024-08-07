import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

import 'package:innovare_campus/components/uiHelper.dart';
import 'package:innovare_campus/model/lostfind.dart';
import 'package:provider/provider.dart';
import 'package:innovare_campus/provider/lostfound_provider.dart';

class UploadItemScreen extends StatefulWidget {
  @override
  _UploadItemScreenState createState() => _UploadItemScreenState();
}

class _UploadItemScreenState extends State<UploadItemScreen> {
  final _formKey = GlobalKey<FormState>();
  String _description = '';
  String _location = '';
  File? _imageFile;

  Future<void> _pickImage() async {
    try {
      if (await Permission.photos.request().isGranted) {
        final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            _imageFile = File(pickedFile.path);
          });
        }
      } else {
        // Handle the case when the user denies the permission
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Photo library permission is required to pick an image.'),
        ));
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  Future<void> _uploadItem() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      try {
        String imageUrl = '';
        if (_imageFile != null) {
          final storageRef = FirebaseStorage.instance.ref().child('lost_found/${DateTime.now().millisecondsSinceEpoch}.png');
          await storageRef.putFile(_imageFile!);
          imageUrl = await storageRef.getDownloadURL();
        }

        final newItem = LostFoundItem(
          id: '', // Firestore will generate the ID
          description: _description,
          location: _location,
          imageUrl: imageUrl,
          timestamp: Timestamp.now(),
        );

        await Provider.of<LostFoundProvider>(context, listen: false).addItem(newItem);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Item successfully uploaded!'),
        ));

        Navigator.pop(context);
      } catch (e) {
        print('Failed to upload item: $e');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to upload item: $e'),
        ));
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
        title: Text('Lost & Found'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4D1DFF), Color(0xFF4D79FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.05),
              Text(
                'Enter Information',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Description of item',
                  labelStyle: TextStyle(color: Colors.white),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) {
                  _description = value!;
                },
              ),
              SizedBox(height: screenHeight * 0.02),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Location of item',
                  labelStyle: TextStyle(color: Colors.white),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: TextStyle(color: Colors.white),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a location';
                  }
                  return null;
                },
                onSaved: (value) {
                  _location = value!;
                },
              ),
              SizedBox(height: screenHeight * 0.02),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.photo_camera, color: Colors.white),
                      SizedBox(width: 8),
                      Text(
                        _imageFile == null ? 'Add Photo' : 'Photo Selected',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: screenHeight * 0.02),
              ElevatedButton(
                onPressed: _uploadItem,
                child: Text('Submit Item'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(49, 42, 119, 1),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
