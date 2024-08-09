import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innovare_campus/model/menu_item.dart';

class MenuProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<MenuItem> _menuItems = [];

  List<MenuItem> get menuItems => _menuItems;

  MenuProvider() {
    _loadMenuItems();
  }

  Future<void> _loadMenuItems() async {
    try {
      final snapshot = await _firestore.collection('menu').get();
      _menuItems = snapshot.docs.map((doc) => MenuItem.fromMap(doc.data(), doc.id)).toList();
      notifyListeners();
    } catch (e) {
      print('Error loading menu items: $e');
    }
  }

  Future<void> addMenuItem(MenuItem item) async {
    try {
      // Add the item to Firestore and get the document reference
      final docRef = await _firestore.collection('menu').add(item.toMap());

      // Update the item's ID with the generated document ID
      item.id = docRef.id;

      // Ensure the Firestore document has the correct ID
      await _firestore.collection('menu').doc(docRef.id).update({'id': item.id});

      // Add the item to the local list and notify listeners
      _menuItems.add(item);
      notifyListeners();
    } catch (e) {
      print('Error adding menu item: $e');
    }
  }

  Future<void> updateMenuItem(MenuItem updatedItem) async {
    try {
      // Update the Firestore document with the updated item details
      await _firestore.collection('menu').doc(updatedItem.id).update(updatedItem.toMap());

      // Find the index of the item to update in the local list
      final index = _menuItems.indexWhere((item) => item.id == updatedItem.id);
      if (index >= 0) {
        _menuItems[index] = updatedItem;
        notifyListeners();
      }
    } catch (e) {
      print('Error updating menu item: $e');
    }
  }

  Future<void> deleteMenuItem(MenuItem item) async {
    try {
      // Delete the item from Firestore
      await _firestore.collection('menu').doc(item.id).delete();

      // Remove the item from the local list and notify listeners
      _menuItems.removeWhere((i) => i.id == item.id);
      notifyListeners();
    } catch (e) {
      print('Error deleting menu item: $e');
    }
  }
}
