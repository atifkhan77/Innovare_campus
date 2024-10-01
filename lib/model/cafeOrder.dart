class CafeOrder {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  int quantity;

  CafeOrder({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    this.quantity = 1,
  });
}

class OrderConfirmation {
  String id;
  String email;
  String orderNumber;
  double totalPayment;
  List<Map<String, dynamic>> items;
  String paymentMethod;
  DateTime timestamp;

  OrderConfirmation({
    required this.id,
    required this.email,
    required this.orderNumber,
    required this.totalPayment,
    required this.items,
    required this.paymentMethod,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'orderNumber': orderNumber,
      'totalPayment': totalPayment,
      'items': items,
      'paymentMethod': paymentMethod,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory OrderConfirmation.fromMap(
      Map<String, dynamic> map, String documentId) {
    return OrderConfirmation(
      id: documentId,
      email: map['email'] ?? '',
      orderNumber: map['orderNumber'] ?? '',
      totalPayment: map['totalPayment']?.toDouble() ?? 0.0,
      items: List<Map<String, dynamic>>.from(map['items'] ?? []),
      paymentMethod: map['paymentMethod'] ?? '',
      timestamp:
          DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }
}
