import 'package:cloud_firestore/cloud_firestore.dart';

class Request {
  final String id;
  final String tutorName;
  final String studentName;
  final String message;
  final String status;

  Request({
    required this.id,
    required this.tutorName,
    required this.studentName,
    required this.message,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'tutorName': tutorName,
      'studentName': studentName,
      'message': message,
      'status': status,
    };
  }

  static Request fromDocument(DocumentSnapshot doc) {
    return Request(
      id: doc.id,
      tutorName: doc['tutorName'],
      studentName: doc['studentName'],
      message: doc['message'],
      status: doc['status'],
    );
  }
}
