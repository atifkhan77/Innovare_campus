import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innovare_campus/model/lostfind.dart';

class LostFoundProvider with ChangeNotifier {
  List<LostFoundItem> _items = [];

  List<LostFoundItem> get items => _items;

  LostFoundProvider() {
    fetchItems();
  }

  Future<void> fetchItems() async {
    final snapshot = await FirebaseFirestore.instance.collection('lost_found').get();
    _items = snapshot.docs.map((doc) => LostFoundItem.fromDocument(doc)).toList();
    notifyListeners();
  }

  Future<void> addItem(LostFoundItem item) async {
    final docRef = await FirebaseFirestore.instance.collection('lost_found').add(item.toMap());
    _items.add(LostFoundItem(
      id: docRef.id,
      description: item.description,
      location: item.location,
      imageUrl: item.imageUrl,
      timestamp: item.timestamp,
    ));
    notifyListeners();
  }
}
