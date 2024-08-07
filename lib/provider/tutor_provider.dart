import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:innovare_campus/model/tutor.dart';
import 'package:innovare_campus/model/request.dart';

class TutorProvider with ChangeNotifier {
  List<Tutor> _tutors = [];
  List<Request> _requests = [];
  String? _tutorName;
  String? _tutorId;

  List<Tutor> get tutors => _tutors;
  List<Request> get requests => _requests;
  String? get tutorName => _tutorName;
  String? get tutorId => _tutorId;

  void setTutor(String name, String id) {
    _tutorName = name;
    _tutorId = id;
    notifyListeners();
  }

  Future<void> fetchCurrentTutor() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      print('Fetching tutor for user: ${user.uid}');
      final doc = await FirebaseFirestore.instance.collection('tutors').doc(user.uid).get();
      if (doc.exists) {
        final tutor = Tutor.fromDocument(doc);
        _tutorName = tutor.name;
        _tutorId = tutor.contactNumber;
        print('Tutor found: $_tutorName');
        notifyListeners();
      } else {
        print('No tutor document found for user: ${user.uid}');
      }
    } else {
      print('No user is currently logged in.');
    }
  }

  void fetchTutors() async {
    final QuerySnapshot result = await FirebaseFirestore.instance.collection('tutors').get();
    final List<Tutor> fetchedTutors = result.docs.map((doc) => Tutor.fromDocument(doc)).toList();
    _tutors = fetchedTutors;
    notifyListeners();
  }

  void addTutor(Tutor tutor) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance.collection('tutors').doc(user.uid).set(tutor.toMap());
      _tutors.add(tutor);
      notifyListeners();
    } else {
      print('No user is currently logged in. Cannot add tutor.');
    }
  }

  Future<void> sendRequest(Request request) async {
    await FirebaseFirestore.instance.collection('requests').add(request.toMap());
    notifyListeners();
  }

  Future<void> fetchRequests() async {
    final QuerySnapshot result = await FirebaseFirestore.instance.collection('requests').get();
    final List<Request> fetchedRequests = result.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final request = Request.fromDocument(doc);
      print('Fetched request: ${data['message']} for tutor: ${data['tutorName']}');
      return request;
    }).toList();
    _requests = fetchedRequests;
    notifyListeners();
  }

  Future<void> acceptRequest(String requestId) async {
    await FirebaseFirestore.instance.collection('requests').doc(requestId).update({'status': 'accepted'});
    await fetchRequests();
  }

  Future<void> declineRequest(String requestId) async {
    await FirebaseFirestore.instance.collection('requests').doc(requestId).update({'status': 'declined'});
    await fetchRequests();
  }
}
