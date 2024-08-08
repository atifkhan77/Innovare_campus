import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:innovare_campus/components/uiHelper.dart';

class CreateGroupScreen extends StatefulWidget {
  const CreateGroupScreen({Key? key}) : super(key: key);

  @override
  State<CreateGroupScreen> createState() => _CreateGroupScreenState();
}

class _CreateGroupScreenState extends State<CreateGroupScreen> {
  final TextEditingController _groupNameController = TextEditingController();
  final List<String> _selectedUsers = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _createGroup() async {
    if (_groupNameController.text.isNotEmpty && _selectedUsers.isNotEmpty) {
      String groupId = _firestore.collection('groups').doc().id;
      await _firestore.collection('groups').doc(groupId).set({
        'name': _groupNameController.text,
        'members': _selectedUsers,
        'admin': _auth.currentUser!.email,
        'createdAt': Timestamp.now(),
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Create Group',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/Splash.png"), // Set your background image here
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _groupNameController,
                decoration: const InputDecoration(
                  labelText: 'Group Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('users').snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final users = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final user = users[index];
                        final userEmail = user['email'];
                        return CheckboxListTile(
                          title: Text(userEmail),
                          value: _selectedUsers.contains(userEmail),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedUsers.add(userEmail);
                              } else {
                                _selectedUsers.remove(userEmail);
                              }
                            });
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              CustomButton(
                onPressed: _createGroup,
                text: 'Create Group',
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }
}
