import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final TextEditingController _recipientEmailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _sendMessage() async {
    if (_messageController.text.isNotEmpty && _recipientEmailController.text.isNotEmpty) {
      String message = _messageController.text;
      String recipientEmail = _recipientEmailController.text;
      String senderId = _auth.currentUser!.uid;
      String senderEmail = _auth.currentUser!.email!;
      Timestamp timestamp = Timestamp.now();

      await _firestore.collection('chats').add({
        'senderId': senderId,
        'senderEmail': senderEmail,
        'recipientEmail': recipientEmail,
        'message': message,
        'timestamp': timestamp,
      });

      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    User? currentUser = _auth.currentUser;
    String currentUserEmail = currentUser?.email ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Chat'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestore.collection('chats')
                  .where('recipientEmail', isEqualTo: currentUserEmail)
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                List<QueryDocumentSnapshot> docs = snapshot.data!.docs;
                List<Map<String, dynamic>> messages = docs.map((doc) => doc.data() as Map<String, dynamic>).toList();

                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(messages[index]['message']),
                      subtitle: Text('From: ${messages[index]['senderEmail']} To: ${messages[index]['recipientEmail']}'),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _recipientEmailController,
                    decoration: InputDecoration(
                      labelText: 'Recipient Email',
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(
                      labelText: 'Message',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
