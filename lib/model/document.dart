import 'package:cloud_firestore/cloud_firestore.dart';

class Document {
  final String id;
  final String name;
  final String url;

  Document({required this.id, required this.name, required this.url});

  factory Document.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Document(
      id: data['id'] ?? '',
      name: data['name'] ?? '',
      url: data['url'] ?? '',
    );
  }
}
