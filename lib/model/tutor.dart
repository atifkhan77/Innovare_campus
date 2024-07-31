import 'package:cloud_firestore/cloud_firestore.dart';

class Tutor {
  final String name;
  final String subjectExpertise;
  final String availability;
  final String contactNumber;

  Tutor({
    required this.name,
    required this.subjectExpertise,
    required this.availability,
    required this.contactNumber,
  });

  factory Tutor.fromDocument(DocumentSnapshot doc) {
    return Tutor(
      name: doc['name'],
      subjectExpertise: doc['subjectExpertise'],
      availability: doc['availability'],
      contactNumber: doc['contactNumber'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'subjectExpertise': subjectExpertise,
      'availability': availability,
      'contactNumber': contactNumber,
    };
  }
}
