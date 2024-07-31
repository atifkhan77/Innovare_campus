import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:innovare_campus/model/tutor.dart';


class TutorProvider with ChangeNotifier {
  List<Tutor> _tutors = [];

  List<Tutor> get tutors => _tutors;

  void fetchTutors() async {
    final QuerySnapshot result = await FirebaseFirestore.instance.collection('tutors').get();
    final List<Tutor> fetchedTutors = result.docs.map((doc) => Tutor.fromDocument(doc)).toList();
    _tutors = fetchedTutors;
    notifyListeners();
  }

  void addTutor(Tutor tutor) async {
    await FirebaseFirestore.instance.collection('tutors').add(tutor.toMap());
    _tutors.add(tutor);
    notifyListeners();
  }
}
