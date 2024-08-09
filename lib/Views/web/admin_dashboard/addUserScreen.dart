import 'package:flutter/material.dart';
import 'package:innovare_campus/model/userModel.dart';
import 'package:innovare_campus/provider/userProvider.dart';
import 'package:provider/provider.dart';

class AddUserScreen extends StatefulWidget {
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Add User'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Email'),
                onSaved: (value) => _email = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Address'),
                onSaved: (value) => _address = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contact Number'),
                onSaved: (value) => _contactNumber = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Profile Image URL'),
                onSaved: (value) => _profileImageUrl = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Registration Number'),
                onSaved: (value) => _regNo = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  _formKey.currentState?.save();
                  final newUser = UserModel(
                    id: '', // Empty ID for new users
                    address: _address,
                    contactNumber: _contactNumber,
                    email: _email,
                    name: _name,
                    profileImageUrl: _profileImageUrl,
                    regNo: _regNo,
                  );
                  await userProvider.addUser(newUser);
                  Navigator.pop(context);
                },
                child: Text('Add User'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
