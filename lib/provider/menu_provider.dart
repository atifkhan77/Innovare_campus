import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:innovare_campus/model/menu_item.dart';

class MenuProvider with ChangeNotifier {
  List<MenuItem> _menuItems = [];

  List<MenuItem> get menuItems => _menuItems;

  // Fetch menu items from Firestore
  Future<void> fetchMenuItems() async {
    final snapshot = await FirebaseFirestore.instance.collection('menu').get();
    _menuItems = snapshot.docs
        .map((doc) => MenuItem.fromMap(doc.data()..['id'] = doc.id))
        .toList();
    notifyListeners();
  }

  // Add menu item to Firestore
  Future<void> addMenuItem(MenuItem item) async {
    await FirebaseFirestore.instance
        .collection('menu')
        .doc(item.id) // Use the generated or existing ID
        .set(item.toMap());
    fetchMenuItems();
  }

  // Update menu item in Firestore
  Future<void> updateMenuItem(MenuItem item) async {
    await FirebaseFirestore.instance
        .collection('menu')
        .doc(item.id)
        .update(item.toMap());
    fetchMenuItems();
  }

  // Delete menu item from Firestore
  Future<void> deleteMenuItem(MenuItem item) async {
    await FirebaseFirestore.instance.collection('menu').doc(item.id).delete();
    fetchMenuItems();
  }

  // Add method to get a new Firestore document ID
  String getNewDocumentId() {
    return FirebaseFirestore.instance.collection('menu').doc().id;
  }
}
