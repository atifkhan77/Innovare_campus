import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:innovare_campus/model/document.dart';
import 'package:uuid/uuid.dart';

class DocumentProvider extends ChangeNotifier {
  List<Document> _documents = [];

  List<Document> get documents => _documents;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> fetchDocuments(String userId) async {
    QuerySnapshot querySnapshot = await _firestore
        .collection('prints')
        .where('userId', isEqualTo: userId)
        .get();

    _documents =
        querySnapshot.docs.map((doc) => Document.fromFirestore(doc)).toList();
    notifyListeners();
  }

  Future<void> uploadDocument(
      PlatformFile file, String userId, int numOfPrints) async {
    try {
      String fileId = const Uuid().v4();
      String fileName = file.name;

      Reference ref = _storage.ref().child('documents/$fileId.pdf');
      UploadTask uploadTask = ref.putData(file.bytes!);
      await uploadTask;

      String downloadURL = await ref.getDownloadURL();

      await _firestore.collection('prints').doc(fileId).set({
        'id': fileId,
        'name': fileName,
        'url': downloadURL,
        'userId': userId,
        'uploadedAt': Timestamp.now(),
        'numOfPrints': numOfPrints,
      });

      _documents.add(Document(
        id: fileId,
        name: fileName,
        url: downloadURL,
        userId: userId,
        numOfPrints: numOfPrints,
      ));
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }

  Future<void> deleteDocument(String id) async {
    try {
      await _storage.ref().child('documents/$id.pdf').delete();

      await _firestore.collection('prints').doc(id).delete();

      _documents.removeWhere((doc) => doc.id == id);
      notifyListeners();
    } catch (e) {
      print(e);
    }
  }
}
