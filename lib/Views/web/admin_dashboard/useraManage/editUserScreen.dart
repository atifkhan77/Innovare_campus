import 'package:flutter/material.dart';
import 'package:innovare_campus/model/userModel.dart';
import 'package:innovare_campus/provider/userProvider.dart';
import 'package:provider/provider.dart';

class EditUserScreen extends StatefulWidget {
  final UserModel user;

  const EditUserScreen({super.key, required this.user});

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _email;

  @override
  void initState() {
    super.initState();
    _name = widget.user.name;
    _email = widget.user.email;
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (value) => _name = value!,
              ),
              TextFormField(
                initialValue: _email,
                decoration: const InputDecoration(labelText: 'Email'),
                onSaved: (value) => _email = value!,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  _formKey.currentState?.save();
                  final updatedUser = UserModel(
                    id: widget.user.id,
                    address: widget.user.address,
                    contactNumber: widget.user.contactNumber,
                    email: _email,
                    name: _name,
                    profileImageUrl: widget.user.profileImageUrl,
                    regNo: widget.user.regNo,
                  );
                  await userProvider.updateUser(updatedUser);
                  Navigator.pop(context);
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
