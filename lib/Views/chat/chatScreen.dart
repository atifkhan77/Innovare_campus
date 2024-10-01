import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:innovare_campus/Views/chat/CreateGroupScreen.dart';
import 'package:innovare_campus/Views/chat/GroupListScreen.dart';
import 'package:innovare_campus/Views/chat/chatBotScreen.dart';
import 'package:innovare_campus/Views/chat/chatPage.dart';
import 'package:innovare_campus/components/uiHelper.dart';

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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/Splash.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    hintText: 'Search',
                    hintStyle: const TextStyle(color: Colors.white),
                    prefixIcon: const Icon(Icons.search, color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                  ),
                ),
              ),
              Expanded(child: _buildUserList()),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildGradientButton(
                      "Comsats Bot",
                      () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const ChatbotScreen()),
                        );
                      },
                      screenWidth * 0.4,
                      screenHeight,
                    ),
                    _buildGradientButton(
                      "Create Group",
                      () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const CreateGroupScreen()),
                        );
                      },
                      screenWidth * 0.4,
                      screenHeight,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ],
      ),
      bottomNavigationBar: const NavBar(),
    );
  }

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
            final profileImageUrl =
                data['profile_image_url'] ?? 'assets/placeholder.png';

            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(profileImageUrl),
                    radius: 30,
                    child: profileImageUrl.isEmpty
                        ? const Icon(Icons.person, color: Colors.white)
                        : null,
                  ),
                  title: Text(
                    data['email'],
                    style: const TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.bold),
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
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildGradientButton(String text, VoidCallback onPressed,
      double buttonWidth, double screenHeight) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
      onPressed: onPressed,
      child: Ink(
        decoration: BoxDecoration(
          color: const Color.fromRGBO(0, 0, 70, 1),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Container(
          constraints: BoxConstraints(
            minWidth: buttonWidth,
            minHeight: screenHeight * 0.06,
          ),
          alignment: Alignment.center,
          child: Text(
            text,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
