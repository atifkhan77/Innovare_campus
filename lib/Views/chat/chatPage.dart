import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:innovare_campus/components/chatBubble.dart';
import 'package:innovare_campus/components/my_text_fild.dart';
import 'package:innovare_campus/components/uiHelper.dart';
import 'package:innovare_campus/controller/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String recieverUserEmail;

  const ChatPage({
    Key? key,
    required this.recieverUserEmail,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final Chatservice _chatservice = Chatservice();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void sendMessage() async {
    if (_messageController.text.isNotEmpty) {
      await _chatservice.sendMessage(
        widget.recieverUserEmail,
        _messageController.text,
      );
      _messageController.clear();
    }
  }

  void deleteMessage(String messageId) async {
    await _chatservice.deleteMessage(
      _firebaseAuth.currentUser!.email!,
      widget.recieverUserEmail,
      messageId,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(49, 42, 119, 1),
        title: Text(
          widget.recieverUserEmail,
          style: const TextStyle(color: Colors.white70),
        ),
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
            Expanded(
              child: _buildMessageList(),
            ),
            _buildMessageInput(),
          ],
        ),
      ),
      // bottomNavigationBar: const NavBar(),
    );
  }

  // Build message list
  Widget _buildMessageList() {
    return StreamBuilder(
      stream: _chatservice.getMessages(
        _firebaseAuth.currentUser!.email!,
        widget.recieverUserEmail,
      ),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(child: Text('No messages yet.'));
        }
        return ListView(
          children: snapshot.data!.docs
              .map((document) => _buildMessageItem(document))
              .toList(),
        );
      },
    );
  }

  // Build message item
  Widget _buildMessageItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;

    var message = data['message'] ?? '';
    var senderId = data['senderId'] ?? '';
    var messageId = document.id;

    var alignment = (senderId == _firebaseAuth.currentUser!.uid)
        ? Alignment.centerRight
        : Alignment.centerLeft;

    return GestureDetector(
      onLongPress: () {
        _showDeleteDialog(messageId);
      },
      child: Container(
        alignment: alignment,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: (senderId == _firebaseAuth.currentUser!.uid)
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            children: [
              ChatBubble(message: message),
            ],
          ),
        ),
      ),
    );
  }

  // Show delete confirmation dialog
  void _showDeleteDialog(String messageId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Message'),
          content: const Text('Are you sure you want to delete this message?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                deleteMessage(messageId);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  // Build message input
  Widget _buildMessageInput() {
    return Row(
      children: [
        // Text field
        Expanded(
          child: MyTextField(
            controller: _messageController,
            hintText: 'Enter Message',
          ),
        ),
        IconButton(
          onPressed: sendMessage,
          icon: const Icon(Icons.arrow_upward),
          iconSize: 40,
        ),
      ],
    );
  }
}
