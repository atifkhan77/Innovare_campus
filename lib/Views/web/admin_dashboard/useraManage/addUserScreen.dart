import 'package:flutter/material.dart';
import 'package:innovare_campus/model/userModel.dart';
import 'package:innovare_campus/provider/userProvider.dart';
import 'package:provider/provider.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  _AddUserScreenState createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _email;
  late String _address;
  late String _contactNumber;
  late String _profileImageUrl;
  late String _regNo;

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Image.asset(
            'assets/Splash.png', // Path to your image
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent, // Make the Scaffold transparent
          appBar: AppBar(
            title: const Text(
              'Add User',
              style: TextStyle(color: Colors.white),
            ),
            centerTitle: true,
            backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Enter User Details',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField('Name', onSaved: (value) => _name = value!),
                  const SizedBox(height: 15),
                  _buildTextField('Email', onSaved: (value) => _email = value!),
                  const SizedBox(height: 15),
                  _buildTextField('Address',
                      onSaved: (value) => _address = value!),
                  const SizedBox(height: 15),
                  _buildTextField('Contact Number',
                      onSaved: (value) => _contactNumber = value!),
                  const SizedBox(height: 15),
                  _buildTextField('Profile Image URL',
                      onSaved: (value) => _profileImageUrl = value!),
                  const SizedBox(height: 15),
                  _buildTextField('Registration Number',
                      onSaved: (value) => _regNo = value!),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          _formKey.currentState?.save();
                          final newUser = UserModel(
                            id: '',
                            address: _address,
                            contactNumber: _contactNumber,
                            email: _email,
                            name: _name,
                            profileImageUrl: _profileImageUrl,
                            regNo: _regNo,
                          );
                          await userProvider.addUser(newUser);
                          Navigator.pop(context);
                        }
                      },
                      child: const Text(
                        'Add User',
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Helper method to build form fields with consistent style
  Widget _buildTextField(String labelText,
      {required Function(String?) onSaved}) {
    return TextFormField(
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.blue),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.black.withOpacity(0.2),
      ),
      onSaved: onSaved,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return '$labelText cannot be empty';
        }
        return null;
      },
    );
  }
}
