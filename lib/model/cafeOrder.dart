class OrderConfirmation {
  String id;
  String email;
  String orderNumber;
  double totalPayment;
  List<Map<String, dynamic>> items; // A list of items in the order
  String paymentMethod;
  DateTime timestamp; // New field for storing the order date and time

  OrderConfirmation({
    required this.id,
    required this.email,
    required this.orderNumber,
    required this.totalPayment,
    required this.items,
    required this.paymentMethod,
    required this.timestamp, // Initialize the timestamp
  });

  // Convert OrderConfirmation to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'orderNumber': orderNumber,
      'totalPayment': totalPayment,
      'items': items,
      'paymentMethod': paymentMethod,
      'timestamp': timestamp.toIso8601String(), // Store as ISO 8601 string
    };
  }

  // Create an OrderConfirmation from a Firestore document snapshot
  factory OrderConfirmation.fromMap(Map<String, dynamic> map, String documentId) {
    return OrderConfirmation(
      id: documentId,
      email: map['email'] ?? '',
      orderNumber: map['orderNumber'] ?? '',
      totalPayment: map['totalPayment']?.toDouble() ?? 0.0,
      items: List<Map<String, dynamic>>.from(map['items'] ?? []),
      paymentMethod: map['paymentMethod'] ?? '',
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()), // Parse the timestamp
    );
  }
}
