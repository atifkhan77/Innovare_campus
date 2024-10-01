import 'package:flutter/material.dart';
import 'package:innovare_campus/model/cafeOrder.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class OrderProvider with ChangeNotifier {
  Future<void> placeOrder(OrderConfirmation order) async {
    final orderRef = FirebaseFirestore.instance.collection('orders').doc();
    order.id = orderRef.id;
    await orderRef.set(order.toMap());
    notifyListeners();
  }
}
