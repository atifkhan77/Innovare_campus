class OrderConfirmation {
  String id;
 
  String email;
  String orderNumber;
  double totalPayment;
  List<Map<String, dynamic>> items; // A list of items in the order
  String paymentMethod;

  OrderConfirmation({
    required this.id,
   
    required this.email,
    required this.orderNumber,
    required this.totalPayment,
    required this.items,
    required this.paymentMethod,
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
    );
  }
}
