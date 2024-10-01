import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:innovare_campus/model/userModel.dart';

class UserProvider with ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<UserModel> _users = [];

  List<UserModel> get users => _users;

  UserProvider() {
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      _users = snapshot.docs.map((doc) {
        final data = doc.data();
        return UserModel.fromMap(data, doc.id);
      }).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading users: $e');
    }
  }

  Future<void> refreshUsers() async {
    await _loadUsers();
  }

  Future<void> addUser(UserModel user) async {
    try {
      final docRef = await _firestore.collection('users').add(user.toMap());
      user.id = docRef.id;
      _users.add(user);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding user: $e');
    }
  }

  Future<void> deleteUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).delete();
      _users.removeWhere((u) => u.id == user.id);
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting user: $e');
    }
  }

  Future<void> updateUser(UserModel user) async {
    try {
      await _firestore.collection('users').doc(user.id).update(user.toMap());
      final index = _users.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        _users[index] = user;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error updating user: $e');
    }
  }
}
