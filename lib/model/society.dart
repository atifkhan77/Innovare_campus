import 'package:cloud_firestore/cloud_firestore.dart';

class Society {
  final String id;
  final String name;
  final String description;
  final String upcomingEvent;
  final String recruitmentDrive;

  Society({
    required this.id,
    required this.name,
    required this.description,
    required this.upcomingEvent,
    required this.recruitmentDrive,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'upcoming_event': upcomingEvent,
      'recruitment_drive': recruitmentDrive,
    };
  }

  static Society fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Society(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      upcomingEvent: data['upcoming_event'] ?? '',
      recruitmentDrive: data['recruitment_drive'] ?? '',
    );
  }
}
