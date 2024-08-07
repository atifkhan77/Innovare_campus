import 'package:cloud_firestore/cloud_firestore.dart';

class LostFoundItem {
  final String id;
  final String description;
  final String location;
  final String imageUrl;
  final Timestamp timestamp;

  LostFoundItem({
    required this.id,
    required this.description,
    required this.location,
    required this.imageUrl,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'location': location,
      'image_url': imageUrl,
      'timestamp': timestamp,
    };
  }

  static LostFoundItem fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return LostFoundItem(
      id: doc.id,
      description: data['description'] ?? '',
      location: data['location'] ?? '',
      imageUrl: data['image_url'] ?? '',
      timestamp: data['timestamp'] ?? Timestamp.now(),
    );
  }
}
