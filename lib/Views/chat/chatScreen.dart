import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:innovare_campus/Views/chat/CreateGroupScreen.dart';
import 'package:innovare_campus/Views/chat/GroupListScreen.dart';
import 'package:innovare_campus/Views/chat/chatPage.dart';
import 'package:innovare_campus/components/uiHelper.dart';
//import 'create_group_screen.dart'; // import the create group screen
//import 'group_list_screen.dart'; // import the group list screen

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
        title: const Text(
          "Chats",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.group,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const GroupListScreen()),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
                "assets/Splash.png"), // Set your background image here
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            Expanded(child: _buildUserList()),
            const SizedBox(height: 20),
            CustomButton(
              text: "Create Group",
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const CreateGroupScreen()),
                );
              },
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
      bottomNavigationBar: const NavBar(),
    );
  }

  // Build the list of logged-in users
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        final users = snapshot.data!.docs.where((doc) {
          final data = doc.data()! as Map<String, dynamic>;
          final email = data['email'] as String;
          final searchQuery = _searchController.text.toLowerCase();
          return email.toLowerCase().contains(searchQuery) &&
              _auth.currentUser!.email != email;
        }).toList();

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final data = users[index].data()! as Map<String, dynamic>;
            return ListTile(
              leading: const CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text(
                data['email'],
                style: const TextStyle(color: Colors.white70),
              ),
              subtitle: const Text(
                'Hey, how are you?',
                style: TextStyle(color: Colors.grey),
              ),
              trailing: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('2h ago', style: TextStyle(color: Colors.grey)),
                  Icon(Icons.message, color: Colors.grey),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      recieverUserEmail: data['email'],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
