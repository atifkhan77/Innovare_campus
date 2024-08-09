

class MenuItem {
  late final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String category;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
  });

  // Convert MenuItem to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
      'category': category,
    };
  }

  // Create a MenuItem from a Firestore document snapshot
  factory MenuItem.fromMap(Map<String, dynamic> map, String documentId) {
    return MenuItem(
      id: documentId,
      name: map['name'] ?? '',
      price: map['price']?.toDouble() ?? 0.0,
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? '',
    );
  }
}
