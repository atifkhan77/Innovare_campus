import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innovare_campus/model/cafeOrder.dart';

class OrderProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> placeOrder(OrderConfirmation order) async {
    try {
      final docRef = await _firestore.collection('orders').add(order.toMap());

      order.id = docRef.id;

      await _firestore
          .collection('orders')
          .doc(docRef.id)
          .update({'id': order.id});

      notifyListeners();
    } catch (e) {
      debugPrint('Error placing order: $e');
      throw Exception('Failed to place order: $e');
    }
  }

  Future<OrderConfirmation?> fetchOrderById(String orderId) async {
    try {
      final doc = await _firestore.collection('orders').doc(orderId).get();
      if (doc.exists) {
        return OrderConfirmation.fromMap(doc.data()!, doc.id);
      }
    } catch (e) {
      debugPrint('Error fetching order: $e');
    }
    return null;
  }
}
