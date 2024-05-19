import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  final String senderId;
  final String senderEmail;
  final String recieverEmail;
  final String message;
  final Timestamp timestamp;

  Message({
    required this.recieverEmail,
    required this.senderId,
    required this.senderEmail,
    required this.message,
    required this.timestamp,
  });

  //convert to map
  Map<String, dynamic> toMap() {
    return {
      'recieverEmail': recieverEmail,
      'senderId': senderId,
      'senderEmail': senderEmail,
      'message': message,
      'timestamp': timestamp,
    };
  }
}
