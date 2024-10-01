import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innovare_campus/model/society.dart';

class SocietyProvider with ChangeNotifier {
  List<Society> _societies = [];

  List<Society> get societies => _societies;

  SocietyProvider() {
    fetchSocieties();
  }

  Future<void> fetchSocieties() async {
    final snapshot =
        await FirebaseFirestore.instance.collection('societies').get();
    _societies = snapshot.docs.map((doc) => Society.fromDocument(doc)).toList();
    notifyListeners();
  }

  Future<void> addSociety(Society society) async {
    final docRef = await FirebaseFirestore.instance
        .collection('societies')
        .add(society.toMap());
    _societies.add(Society(
      id: docRef.id,
      name: society.name,
      description: society.description,
      upcomingEvent: society.upcomingEvent,
      recruitmentDrive: society.recruitmentDrive,
    ));
    notifyListeners();
  }

  Future<void> updateSociety(Society society) async {
    await FirebaseFirestore.instance
        .collection('societies')
        .doc(society.id)
        .update(society.toMap());
    final index = _societies.indexWhere((s) => s.id == society.id);
    if (index != -1) {
      _societies[index] = society;
      notifyListeners();
    }
  }

  Future<void> deleteSociety(String id) async {
    await FirebaseFirestore.instance.collection('societies').doc(id).delete();
    _societies.removeWhere((s) => s.id == id);
    notifyListeners();
  }
}
