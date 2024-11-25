import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:innovare_campus/Views/chat/GroupChatScreen.dart';

class GroupListScreen extends StatelessWidget {
  const GroupListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Groups',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/Splash.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder<QuerySnapshot>(
          stream: firestore.collection('groups').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            final groups = snapshot.data!.docs.where((doc) {
              final data = doc.data()! as Map<String, dynamic>;
              final members = data['members'] as List<dynamic>;
              return members.contains(auth.currentUser!.email);
            }).toList();

            return ListView.builder(
              itemCount: groups.length,
              itemBuilder: (context, index) {
                final group = groups[index];
                final groupName = group['name'];
                final groupId = group.id;

                return ListTile(
                  title: Text(
                    groupName,
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      firestore.collection('groups').doc(groupId).delete();
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GroupChatScreen(groupId: groupId),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
