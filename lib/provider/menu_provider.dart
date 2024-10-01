import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:innovare_campus/model/menu_item.dart';

class MenuProvider with ChangeNotifier {
  List<MenuItem> _menuItems = [];

  List<MenuItem> get menuItems => _menuItems;

  Future<void> fetchMenuItems() async {
    final snapshot = await FirebaseFirestore.instance.collection('menu').get();
    _menuItems = snapshot.docs
        .map((doc) => MenuItem.fromMap(doc.data()..['id'] = doc.id))
        .toList();
    notifyListeners();
  }

  Future<void> addMenuItem(MenuItem item) async {
    await FirebaseFirestore.instance
        .collection('menu')
        .doc(item.id)
        .set(item.toMap());
    fetchMenuItems();
  }

  Future<void> updateMenuItem(MenuItem item) async {
    await FirebaseFirestore.instance
        .collection('menu')
        .doc(item.id)
        .update(item.toMap());
    fetchMenuItems();
  }

  Future<void> deleteMenuItem(MenuItem item) async {
    await FirebaseFirestore.instance.collection('menu').doc(item.id).delete();
    fetchMenuItems();
  }

  String getNewDocumentId() {
    return FirebaseFirestore.instance.collection('menu').doc().id;
  }
}
