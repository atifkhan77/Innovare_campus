import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:innovare_campus/model/message.dart';

class Chatservice extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Send message
  Future<void> sendMessage(String recieverEmail, String message) async {
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email!;
    final Timestamp timestamp = Timestamp.now();

    // Create message
    Message newMessage = Message(
      senderId: currentUserId,
      senderEmail: currentUserEmail,
      timestamp: timestamp,
      message: message,
      recieverEmail: recieverEmail,
    );

    // Construct chatroom ID from current user email and receiver email
    List<String> emails = [currentUserEmail, recieverEmail];
    emails.sort();
    String chatRoomId = emails.join("_");

    // Add new message to database
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages') // Ensure collection name is consistent
        .add(newMessage.toMap());
  }

  // Get messages
  Stream<QuerySnapshot> getMessages(String userEmail, String otherUserEmail) {
    List<String> emails = [userEmail, otherUserEmail];
    emails.sort();
    String chatRoomId = emails.join("_");

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages') // Ensure collection name is consistent
        .orderBy('timestamp', descending: false) // Ensure field name is consistent
        .snapshots();
  }

  // Delete message
  Future<void> deleteMessage(String userEmail, String otherUserEmail, String messageId) async {
    List<String> emails = [userEmail, otherUserEmail];
    emails.sort();
    String chatRoomId = emails.join("_");

    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .doc(messageId)
        .delete();
  }
}
